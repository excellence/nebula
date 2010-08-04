class Proposal < ActiveRecord::Base
  has_many :votes
  has_many :amendments
  belongs_to :state
  belongs_to :state_change
  belongs_to :character
  belongs_to :user
  validates_presence_of :title
  validates_presence_of :body
  validates_length_of :title, :within => 10..255
  validates_presence_of :state_id
  validates_presence_of :state_change_id
  validates_presence_of :character_id
  validates_presence_of :user_id
  
  # This is the main method for doing any voting. All voting should basically use this.
  # Pass in an Account ID, and a value.
  # The value can be either 1, -1 or 0. 1 or -1 will vote positively or negatively as appropriate; 0 will delete an existing vote.
  def vote!(account_id, value)
    account = Account.find(account_id, :include=>[:user, :character])
    raise ArgumentError, "No such account" if !account
    raise ArgumentError, "Invalid value for vote passed" if value not in [-1, 0, 1] # Stops errant votes with wrong values
    Proposal.transaction do
      Vote.transaction do
        v = Vote.find(:first, :conditions => {:proposal_id => self.id, :account_id => account_id })
        if !v and value != 0
          v = Vote.new
          v.account = account
          v.user = account.user
          v.character = account.character
          v.proposal = self
          v.value = value
          v.save!
          self.votes = self.votes + value
          self.save!
        else
          # Setting to zero means destroy the vote
          if value == 0
            v.destroy!
            self.votes = self.votes - value
            self.save!
          else
            # Otherwise, we want to update the vote with the new value.
            v.value = value
            v.save!
            self.votes = self.votes - v.value
            self.votes = self.votes + value
            self.save!
          end
        end
      end
    end
  end
  # This sets the number of votes stored in the Proposal's votes column to be the number of votes currently out there and enabled.
  # Messy and hits everything. Don't do it unless you have to.
  def recalculate_votes!
    self.votes = Vote.find(:all, :conditions => ['proposal_id = ? AND value IN (-1, 1) AND enabled',self.id], :select => 'value').map{|v|v.value}.sum
    self.save!
  end
  
end
