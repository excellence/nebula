require 'spec_helper'

describe Account do
  
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :character_id => 3004161,
      :api_uid => 503443,
      :api_key => "B9F4471204C1444E9F8C256E2105593EECAD4BE619AE4B048531C0C6A086F705",
      :validated => false
    }
    @account = Account.new
  end

  it "should be valid given valid attributes" do
    @account.attributes = @valid_attributes
    @account.user = User.find_by_id(1)
    @account.should be_valid
  end
  it "should not be valid without a user ID" do
    @account.attributes = @valid_attributes.except(:user_id)
    @account.should_not be_valid
  end
  it "should not be valid without an API User ID" do
    @account.attributes = @valid_attributes.except(:api_uid)
    @account.should_not be_valid
    @account.errors.on(:api_uid).should == ["can't be blank", "is not a number"]
  end
  it "should not be valid without an API Key" do
    @account.attributes = @valid_attributes.except(:api_key)
    @account.should_not be_valid
    @account.errors.on(:api_key).should == ["can't be blank", "is the wrong length (should be 64 characters)"]
  end
  it "should not be valid without any parameters" do
    @account.should_not be_valid
  end
  
end
