require 'spec_helper'

describe Character do
  
  fixtures :accounts
  
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :account_id => 1,
      :name => "Test Character",
      :corporation_id => 1,
      :alliance_id => 1,
      :gender => "Female",
      :race => "Amarr",
      :bloodline => "Vherokior"
    }
    @character = Character.new
  end

  it "should be valid given valid attributes" do
    @character.attributes = @valid_attributes
    @character.should be_valid
  end
  it "should not be valid given no attributes" do
    @character.should_not be_valid
  end
end
