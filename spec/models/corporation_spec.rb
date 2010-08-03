require 'spec_helper'

describe Corporation do
  before(:each) do
    @valid_attributes = {
      :name => "Test Corporation",
      :ticker => "TESTT",
      :alliance_id => 1,
      :member_count => 1
    }
    @corporation = Corporation.new
  end

  it "should be valid given valid attributes" do
    @corporation.attributes = @valid_attributes
    @corporation.should be_valid
  end
  it "should not be valid given no attributes" do
    @corporation.should_not be_valid
  end
  
end
