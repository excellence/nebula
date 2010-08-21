# An account represents an EVE Online account, with one or more characters on that account.
# This account also stores the API key and user ID used to validate that account.
# API key is stored encrypted using the attr_encrypted gem. Symmetric key used to encrypt the keys is defined in config/initializers/encryption.rb and is defined as API_KEY_ENCRYPTION_KEY
class Account < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  attr_accessible :api_key, :api_uid, :character_id
  attr_encrypted :api_key, :key=>API_KEY_ENCRYPTION_KEY, :encode => true
  
  belongs_to :user
  # Selected voting character
  belongs_to :character
  # All character on this account
  has_many :characters
  has_many :votes
  has_many :characters
  has_many :account_state_changes
  
  validates_presence_of :user_id
  validates_presence_of :api_key
  validates_length_of :api_key, :is=>64
  validates_presence_of :api_uid
  validates_numericality_of :api_uid
  
  before_save :handle_vote_status

  # This method handles marking votes this account owns as enabled or disabled when the state of the account changes based on API validation failing or not.
  # FIXME: Currently touches all votes even if there's nothing to do, ie updating API key will force refresh and enable all votes when validated.
  def handle_vote_status
    if self.validated? 
      self.votes.each do |vote|
        vote.enable!
      end
    else
      self.votes.each do |vote|
        vote.disable!
      end
    end
  end
  
  # Creates a new AccountStateChange and updates account_state_id
  def set_state new_state
    raise ArgumentError.new("Can not set the account state to #{new_state.to_s}") unless new_state
    return if (state && state.id == new_state.id)
    AccountStateChange.create!(:account_id => self.id, :account_state_id => new_state.id)
    self.account_state_id = new_state.id
    self.save!  
  end
  
  # Finds the last account state change
  def state
    AccountState.find(self.account_state_id) if self.account_state_id
  end
  #memoize :state
  
  # Asynchronously call the Account#update! method using Resque
  # high_priority is the only option and defaults to false; if true, will enqueue on a high priority queue that may have more workers assigned to it
  def async_update!(high_priority=false)
    Resque::Job.create((high_priority ? "critical" : "account_updates"), "UpdateAccountJob", self.id)
  end
  
  # Primary method for updating this account against the EVE Online API.
  # Calling this method will poke the API server and update stored details, and mark this account as validated or not as appropriate, updating the timestamp if valid.
  def update!
    begin
      highest_sp = 0
      highest_sp_character = nil
      self.reve.characters.each do |character|
        sheet = self.reve.character_sheet(:characterid=>character.id)
        Character.transaction do 
          c = Character.find_or_initialize_by_id(sheet.id)
          # associations
          c.user_id = self.user_id
          c.account_id = self.id
          # attributes
          c.name = sheet.name
          c.gender = sheet.gender
          c.race = sheet.race
          c.bloodline = sheet.bloodline
          # Calculate the SP total - we don't store this - and mark this as the highest SP char on this account if appropriate so we can set this as the primary character later.
          sp_total = sheet.skills.sum(&:skillpoints)
          if sp_total > highest_sp
            highest_sp = sp_total
            highest_sp_character = c
          end
          c.skill_points = sp_total
          c.corporation_id = sheet.corporation_id
          # Now handle corporation loading
          corpsheet = self.reve.corporation_sheet(:characterid=>character.id)
          corp = Corporation.find_or_initialize_by_id(corpsheet.id)
          corp.name = corpsheet.name
          corp.ticker = corpsheet.ticker
          corp.alliance_id = corpsheet.alliance_id
          c.alliance_id = corpsheet.alliance_id
          c.save!
          # Check to see if we have this alliance - if not, update from the API.
          # TODO: This takes _ages_ so we should do this on a cronjob to ensure we don't do this often in-request
          if corp.alliance_id and corp.alliance_id > 0 and !Alliance.find_by_id(corp.alliance_id)
            Alliance.do_update
          end
          corp.member_count = corpsheet.member_count
          corp.save!
        end
      end
      Account.transaction do
        # Set the account's active character to the char with the most SP if this is not set yet.
        if !self.character
          self.character = highest_sp_character
        end
        # Account is validated if the selected character has more then 3m skill points
        if self.character && self.character.skill_points > 3_000_000
          self.validated = true
          self.set_state AccountState.find_by_name('Validated')
        elsif self.character && self.character.skill_points < 3_000_000
          self.validated = false
          self.set_state AccountState.find_by_name('Validation pending due to low SP')
        end
        # Account is not validated if the user already has two accounts 
        if self.user.accounts.length > 2
          self.validated = false
          self.set_state AccountState.find_by_name('Validation pending due to account count')
        end
        # Account is not validated if the user is using the same ip as another user
        if User.count('*', :conditions => ["current_sign_in_ip = ? OR last_sign_in_ip = ?",self.user.current_sign_in_ip,self.user.last_sign_in_ip]) > 1
          self.validated = false
          self.set_state AccountState.find_by_name('Validation pending due to IP checks')
        end
        self.save!
      end
    # TODO: More debugging output in these blocks
    rescue Reve::Exceptions::AuthenticationFailure => e 
      self.set_state AccountState.find_by_name('Invalid')
      self.validated = false
      self.save!
    rescue Reve::Exceptions::LoginDeniedByAccountStatus => e 
      self.set_state AccountState.find_by_name('Inactive')
      self.validated = false
      self.save!
    rescue Reve::Exceptions::ReveError => e 
      self.validated = false
      self.save!
    end
  end

  # Checks the wallet journal of the project nebula character and validates every account for which a player donation has been registered
  def self.validate_pending_accounts!
    #TODO: set the api key somewhere
    reve = Reve::API.new
    journal = reve.personal_wallet_journal(:characterid => 1111111)
    journal.each do |e|
      # TODO: set the character_id if the project nebula character
      if e.owner_id2 == 111111 && e.reftype_id == 10
        char = Character.find(e.owner_id1)
        next unless char
        acc = char.account
        if [5,6,7].include? acc.account_state_id
          Account.transaction do
            acc.set_state AccountState.find_by_name('Manually validated')
            acc.validated = true
            acc.save!
          end
        end
      end
    end
  end
  
  def select_character!(char)
    char = Character.find(char) if char.class != Character
    if char.skill_points > 3_000_000
      self.character = char
      self.set_state AccountState.find_by_name('Validated')
      self.validated = true
    else
      self.validated = false
    end
    self.save!
  end  
  # Helper: Returns a new Reve::API object with API key, API user ID and character ID already initialized
  def reve
    Reve::API.new(self.api_uid, self.api_key, self.character_id)
  end
end
