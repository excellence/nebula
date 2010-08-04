require 'spec_helper'

describe Amendment do
  before(:each) do
    @valid_attributes = {
      :proposal_id => 1,
      :user_id => 1,
      :character_id => 1,
      :title => "value for title",
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    Amendment.create!(@valid_attributes)
  end
end
