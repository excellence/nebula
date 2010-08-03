require 'spec_helper'

describe StateChange do
  before(:each) do
    @valid_attributes = {
      :issue_id => 1,
      :from_state_id => 1,
      :to_state_id => 1,
      :user_id => 1,
      :reason => "value for reason"
    }
    @state_change = StateChange.new
  end

  it "should be valid given valid attributes" do
    @state_change.attributes = @valid_attributes
    @state_change.should be_valid
  end
  it "should not be valid given no attributes" do
    @state_change.should_not be_valid
  end
  
end
