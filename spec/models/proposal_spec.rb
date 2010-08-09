require 'spec_helper'

describe Proposal do
  
  fixtures :proposals, :states, :state_changes
  
  before(:each) do
    @valid_attributes = {
      :state_id => 1,
      :state_change_id => 1,
      :character_id => 1,
      :user_id => 1,
      :title => "Test proposal",
      :body => "This is the test content of the test proposal 1",
      :score => 0
    }
    @proposal = Proposal.new
  end

  it "should be valid given valid attributes" do
    @proposal.attributes = @valid_attributes
    @proposal.should be_valid
  end
  
  it "should not be valid given no attributes" do
    @proposal.should_not be_valid
  end
  
  it "should increment the score by one when a positive vote is added" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>1}
    v.save!
    @proposal.add_vote(v)
    (t+1).should == @proposal.score
  end
  
  it "should decrement the score by one when a positive vote is removed" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>1}
    v.save!
    @proposal.remove_vote(v)
    (t-1).should == @proposal.score
  end
  
  it "should decrement the score by one when a negative vote is added" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>-1}
    v.save!
    @proposal.add_vote(v)
    (t-1).should == @proposal.score
  end
  
  it "should increment the score by one when a negative vote is removed" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>-1}
    v.save!
    @proposal.remove_vote(v)
    (t+1).should == @proposal.score
  end
  
  it "should correctly register a new positive vote when no other votes exist" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    a = Account.find(:first)
    @proposal.vote!(a.id, 1)
    @proposal.score.should == 1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == 1
  end
  
  it "should correctly register a new negative vote when no other votes exist" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    a = Account.find(:first)
    @proposal.vote!(a.id, -1)
    @proposal.score.should == -1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == -1
  end
  
  it "should correctly update an existing positive vote to a negative vote" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    a = Account.find(:first)
    @proposal.vote!(a.id, 1)
    @proposal.vote!(a.id, -1)
    @proposal.score.should == -1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == -1
  end
  
  it "should correctly update an existing negative vote to a positive vote" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    a = Account.find(:first)
    @proposal.vote!(a.id, -1)
    @proposal.vote!(a.id, 1)
    @proposal.score.should == 1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == 1
  end
  
  it "should correctly remove an existing vote when passed a value of 0" do
    @proposal.attributes = @valid_attributes
    @proposal.save!
    a = Account.find(:first)
    @proposal.vote!(a.id, 1)
    @proposal.vote!(a.id, 0)
    @proposal.score.should == 0
    @proposal.votes.length.should == 0
  end
  
end
