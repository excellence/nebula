class Proposal < ActiveRecord::Base
  acts_as_taggable
  
  has_many :votes
  has_many :amendments
  has_many :state_changes
  belongs_to :state
  belongs_to :state_change
  belongs_to :character
  belongs_to :user
  validates_presence_of :title
  validates_presence_of :body
  validates_length_of :title, :within => 10..255
  # The initiate_state callback will take care about state_id and state_change_id
  #validates_presence_of :state_id
  #validates_presence_of :state_change_id
  validates_presence_of :character_id
  validates_presence_of :user_id
  attr_protected :score
  
  before_create :initiate_state
  
  def initiate_state
    self.state = State.find_by_name('New')
    self.state_changes << StateChange.create!(:user_id => self.user_id, :character_id => self.character_id, :to_state_id => self.state_id, :reason => 'Proposal created.')
    self.state_change = self.state_changes.first
  end  
  
  # TODO: Implement me
  def can_edit?(user)
  end
  # TODO: Implement me
  def can_delete?(user)
  end
  # TODO: Implement me
  def can_vote?
  end
  # TODO: Implement me
  def can_propose_amendments?(user)
  end
  # TODO: Implement me
  def can_approve_amendments?(user)
  end
  
  # This is the main method for doing any voting. All voting should basically use this.
  # Pass in an Account ID, and a value.
  # The value can be either 1, -1 or 0. 1 or -1 will vote positively or negatively as appropriate; 0 will delete an existing vote.
  # TODO: This method should check if the account is eligible to vote based on API status and raise an exception if it is not
  # TODO: This method should check if the proposal is open for voting and raise an exception if it is not
  def vote!(account_id, value)
    account = Account.find(account_id, :include=>[:user, :character])
    raise ArgumentError, "No such account" unless account
    raise ArgumentError, "Invalid value for vote passed" unless [-1, 0, 1].include?(value) # Stops errant votes with wrong values
    raise SecurityError, "Account is not validated" unless account.validated?
    raise SecurityError, "Proposal is in a state where voting is not allowed" if self.state && !self.state.can_vote?
    Proposal.transaction do
      Vote.transaction do
        # Find any existing vote for this proposal/account
        v = Vote.find(:first, :conditions => {:proposal_id => self.id, :account_id => account_id })
        if !v and value != 0
          # If we don't exist yet and we're not trying to delete a vote:
          v = Vote.new
          v.account = account
          v.user = account.user
          v.character = account.character
          v.proposal = self
          v.value = value
          v.save!
          self.add_vote(v)
          self.save!
        elsif v
          # We've got a vote already, so we want to update/delete that existing vote.
          # Setting to zero means destroy the vote
          if value == 0
            v.destroy
            self.remove_vote(v)
            self.save!
          else
            # Otherwise, we want to update the vote with the new value.
            self.remove_vote(v)
            v.value = value
            v.save!
            self.add_vote(v)
            self.save!
          end
        end
      end
    end
  end
  
  # Remove a vote from the score - this is not updating models, just the proposal's score column
  def remove_vote(vote)
    self.score = self.score - vote.value
    self.votes_count = self.votes_count - 1
  end
  
  # Add a vote to the score - this is not updating models, just the proposal's score column. Will only add a vote if the vote is enabled.
  def add_vote(vote)
    self.score = self.score + vote.value
    self.votes_count = self.votes_count + 1
  end
  
  # This sets the score stored in the Proposal's score column to be the total score of all votes enabled on this proposal
  # This should not be called often - all methods working on Votes and Proposals should always update the score column accordingly.
  # Messy and hits everything. Don't do it unless you have to.
  def recalculate_score!
    self.score = Vote.find(:all, :conditions => ['proposal_id = ? AND value IN (-1, 1)',self.id], :select => 'value').map{|v|v.value}.sum
    self.save!
  end
  
  def recalculate_votes_count!
    self.votes_count = self.votes.find(:all).length
    self.save!
  end
  
  # Overriding for pretty URLs. Because we're pretty. Too darn pretty. That, and we love SEO! Rails does to_i on this before using it as a parameter, so keep $ID-whateverelse and it works.
  def to_param
    "#{self.id}-#{self.title.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  # Returns (in hopefully a DB/RAM-friendly manner) an array of [[User, count], ...] where count is the number of enabled Votes this User has on the Proposal.
  def voters
    # Get an array of User IDs, with duplicate user IDs for multiple votes.
    user_ids = self.votes.find(:all, :select=>'user_id').map{|v|v.user_id}
    # Turn this into an array of [id, count]
    uc = user_ids.inject(Hash.new(0)){|h,x| h[x]+=1;h}.sort
    # Now load users - note we get all users in one query here, plus characters since we'll want them.
    users = User.find(:all, :select => 'id,character_id', :conditions => {:id => user_ids.uniq}, :include => :character)
    # FIXME: Make this prettier. And possibly faster. Either 
    uc.each do |elem|
      elem[0] = users.select{|u|u.id == elem[0]}[0]
    end
    return uc
  end
  
end
