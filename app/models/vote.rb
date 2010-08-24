# A Vote represents a single Account voting on a single proposal.
# Multiple Accounts voting result in multiple Votes being made.
# A Vote has a value - 1 indicates an upvote, -1 indicates a negative vote, and 0 indicates that this vote is in limbo (account not verifiable by API)
# You should not manipulate these models directly in most cases - use the methods in Proposal to handle voting on an issue.
class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  belongs_to :proposal
  belongs_to :character
  
  validates_presence_of :value
  validates_numericality_of :value, :on => :create, :message => "is not a number"
  validates_inclusion_of :value, :in => [-1,0,1], :message => "value %s is not a valid vote value"
  validates_presence_of :user_id
  validates_presence_of :account_id
  validates_presence_of :proposal_id
  validates_presence_of :character_id
  validate_on_create :check_for_duplicates
  
  # This method will stop duplicate votes being created. There is also a database key to stop this just in case, since we won't be using table locks.
  def check_for_duplicates
    if Vote.find(:first, :conditions => {:proposal_id => self.proposal_id, :account_id => self.account_id})
      errors.add_to_base("Account has already voted on this proposal - alter the existing vote or delete it and create a new one")
    end
  end
  
  # This method will create or update a Vote on a Proposal from an Account.
  # If the Account it is passed is not validated, the Vote will be recorded but not enabled.
  def vote!(proposal, account, score)
    # FIXME: Implement
  end
  
  # Enable or disable a vote, and update the proposal's total accordingly.
  def set_enabled!(enabled)
    Proposal.transaction do
      Vote.transaction do
        if enabled
          self.enabled = true
          self.proposal.add_vote(self)
        else
          self.enabled = false
          self.proposal.remove_vote(self)
        end
        self.save!
        self.proposal.save!
      end
    end
  end
  
  # Enable this vote using set_enabled!
  def enable!
    set_enabled!(true)
  end
  # Disable this vote using set_enabled!
  def disable!
    set_enabled!(false)
  end
  
end
