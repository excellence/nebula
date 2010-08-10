require 'spec_helper'

describe Amendment do
  before(:each) do
    @valid_attributes = {
      :proposal_id => 1,
      :user_id => 1,
      :character_id => 1,
      :title => "value for title",
      :body => "value for body",
      :approving_user_id=>1,
      :approving_character_id=>1  
    }
    @amendment = Amendment.new
  end

  it "should be valid given valid attributes" do
    @amendment.attributes = @valid_attributes
    @amendment.should be_valid
  end
  it "should not be valid given no attributes" do
    @amendment.should_not be_valid
  end
end
