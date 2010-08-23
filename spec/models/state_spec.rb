require 'spec_helper'

describe State do
  fixtures :state_changes
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description"
    }
    @state = State.new
  end

  it "should be valid given valid attributes" do
    @state.attributes = @valid_attributes
    @state.should be_valid
  end
  
  it "should not be valid given no attributes" do
    @state.should_not be_valid
  end
  
  it "should be seeded" do
    State.find(:all).length.should > 0
  end
  
end
