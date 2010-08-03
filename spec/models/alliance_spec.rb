require 'spec_helper'

describe Alliance do
  before(:each) do
    @valid_attributes = {
      :name => "Nebula Test Alliance",
      :ticker => "NEBUL",
      :corporation_count => 1,
      :member_count => 1
    }
    @alliance = Alliance.new
  end

  it "should be valid given valid attributes" do
    @alliance.attributes = @valid_attributes
    @alliance.should be_valid
  end
  
  it "should not be valid given no attributes" do
    @alliance.should_not be_valid
  end
  
end
