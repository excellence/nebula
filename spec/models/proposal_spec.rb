require 'spec_helper'

describe Proposal do
  
  fixtures :proposals, :states, :state_changes
  
  before(:each) do
    @valid_attributes = {
      :state_id => 1,
      :state_change_id => 1,
      :character_id => 1,
      :user_id => 1,
      :title => "Test proposal",
      :body => "This is the test content of the test proposal 1",
      :votes => 1
    }
    @proposal = Proposal.new
  end

  it "should be valid given valid attributes" do
    @proposal.attributes = @valid_attributes
    @proposal.should be_valid
  end
  
  it "should not be valid given no attributes" do
    @proposal.should_not be_valid
  end
  
end
