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
    
end
