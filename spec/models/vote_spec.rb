require 'spec_helper'

describe Vote do
  
  fixtures :proposals, :votes
  
  before(:each) do
    @valid_attributes = {
      :proposal_id => 1,
      :user_id => 1,
      :character_id => 1,
      :account_id => 1,
      :value => 1
    }
    @vote = Vote.new
  end

  it "should be valid given valid attributes and no preexisting votes" do
    @vote.attributes = @valid_attributes
    @vote.should be_valid
  end
  
  it "should not be valid given no attributes" do
    @vote.should_not be_valid
  end
  
  it "should not be valid if a vote has already been cast by this account on this proposal" do
    Vote.create(@valid_attributes)
    @vote.attributes = @valid_attributes
    @vote.should_not be_valid
  end
  
  it "should only be valid if the value is -1, 0 or 1" do
    @vote.attributes = @valid_attributes
    @vote.value = 1
    @vote.should be_valid
    @vote.value = -1
    @vote.should be_valid
    @vote.value = 0
    @vote.should be_valid
    @vote.value = 2
    @vote.should_not be_valid
    @vote.value = -2
    @vote.should_not be_valid
  end
  
  it "should update a proposal's vote count when being disabled and enabled" do
    @vote.attributes = @valid_attributes
    @vote.proposal = Proposal.find(:first)
    @vote.value = 1
    @vote.save!
    t = @vote.proposal.score
    @vote.disable!
    t.should == (@vote.proposal.score - 1)
    @vote.enable!
    t.should == @vote.proposal.score
    @vote.value = -1
    @vote.save!
    t = @vote.proposal.score
    @vote.disable!
    t.should == (@vote.proposal.score + 1)
    @vote.enable!
    t.should == @vote.proposal.score
  end
  
end
