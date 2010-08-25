require 'spec_helper'

describe Vote do
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
    @vote.proposal = Factory.build(:proposal)
    @vote.value = 1
    @vote.save!

    lambda do
      @vote.disable!
    end.should change { @vote.proposal.score }.by(-1)

    lambda do
      @vote.enable!
    end.should change { @vote.proposal.score }.by(1)

    lambda do
      @vote.disable!
      @vote.enable!
    end.should change { @vote.proposal.score }.by(0)
  end
  
end
