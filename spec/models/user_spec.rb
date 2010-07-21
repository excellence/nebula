require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :email => 'test@evenebula.org',
      :password => 'testpassword',
      :password_confirmation => 'testpassword'
    }
    @user = User.new
  end  

  it "should be invalid without an email" do
    @user.attributes = @valid_attributes.except(:email)
    @user.should_not be_valid
    @user.errors.on(:email).should == "can't be blank"
  end

  it "should be invalid without a password" do
    @user.attributes = @valid_attributes.except(:password)
    @user.should_not be_valid
  end

  it "should be valid with a full set of valid attributes" do
    @user = User.new(@valid_attributes)
    @user.should be_valid
  end
end
