require 'spec_helper'

describe Issue do
  
  fixtures :issues, :states, :state_changes
  
  before(:each) do
    @valid_attributes = {
      :state_id => 1,
      :state_change_id => 1,
      :character_id => 1,
      :user_id => 1,
      :title => "Test Issue",
      :body => "This is the test content of the test issue 1",
      :votes => 1
    }
    @issue = Issue.new
  end

  it "should be valid given valid attributes" do
    @issue.attributes = @valid_attributes
    @issue.should be_valid
  end
  
  it "should not be valid given no attributes" do
    @issue.should_not be_valid
  end
  
end
