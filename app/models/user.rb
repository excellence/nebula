# The User model represents one user on the system, who can have many accounts. 
# The Devise authentication framework is used for the majority of legwork this model does.
class User < ActiveRecord::Base
  devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :activatable
  
  has_many :accounts
  has_many :characters
  has_many :proposals
  has_many :amendments
  has_many :state_changes
  has_many :votes
  belongs_to :character
  
  # attr_accessible sets attributes that can be accessed outside the model; keep this to the minimum for security.
  attr_accessible :email, :password, :password_confirmation, :character_id
  # Return a friendly name by which to address this user in views. Defaults to email
  # TODO: Make this use a user's automatically (manually?) determined main character name.
  def name
    if !self.character
      self.email
    else
      self.character.name
    end
  end
  # Gets an array of all characters on validated accounts, prefetches characters and their corp/alliances
  def validated_characters
    self.accounts.find(:all, :conditions => ['validated = true'], :include=>{:characters => [:corporation, :alliance]}).collect(&:characters).flatten
  end
  # Gets an array of all characters on invalidated accounts, prefetches characters and their corp/alliances
  def invalidated_characters
    self.accounts.find(:all, :conditions => ['validated = false'], :include=>{:characters => [:corporation, :alliance]}).collect(&:characters).flatten
  end
  # Gets an array of all validated accounts
  def validated_accounts
    self.accounts.find(:all, :conditions => ['validated = true'])
  end
  # Gets an array of all invalidated accounts
  def invalidated_accounts
    self.accounts.find(:all, :conditions => ['validated = false'])
  end
  
  # Automatically selects the primary character for this User as the highest skill point validated character on the User's validated Accounts, or sets
  # the character_id column to null if the User has no validated Accounts.
  # Accepts a blacklisted character array.
  def autoselect_primary_character!(blacklist=[])
    c = self.validated_characters - blacklist
    if !c or c.length == 0
      self.character = nil
      self.save!
      return true
    else
      sp = 0
      highest_sp_char = nil
      c.each do |char|
        if char.skill_points > sp
          sp = char.skill_points
          highest_sp_char = char
        end
      end
      self.character = char
      self.save!
      return true
    end
  end
end
