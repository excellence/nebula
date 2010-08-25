require 'spec_helper'

describe Proposal do
  
  before(:each) do
    @proposal = Factory.create(:proposal)
    @valid_attributes = {
      :state_id => 1,
      :state_change_id => 1,
      :character_id => 1,
      :user_id => 1,
      :title => "Test proposal",
      :body => "This is the test content of the test proposal 1",
      :score => 0
    }
  end

  it "should be valid given valid attributes" do
    @proposal.should be_valid
  end
  
  it "should not be valid given no attributes" do
    @proposal = Proposal.new
    @proposal.should_not be_valid
  end
  
  it "should be taggable" do
    @proposal.tag_list = "pvp, lowsec"
    @proposal.tag_list.should == ['pvp', 'lowsec']
  end
  
  it "should not allow votes if in a state where voting is not allowed" do
    State.find(:all, :conditions => {:can_vote => false}).each do |state|
      @proposal.state = state
      lambda { @proposal.vote!(Account.find(:first), 1)}.should raise_error(SecurityError)
    end
  end
  it "should increment the score by one when a positive vote is added" do
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>1}
    v.save!
    @proposal.add_vote(v)
    (t+1).should == @proposal.score
  end
  
  it "should decrement the score by one when a positive vote is removed" do
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>1}
    v.save!
    @proposal.remove_vote(v)
    (t-1).should == @proposal.score
  end
  
  it "should decrement the score by one when a negative vote is added" do
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>-1}
    v.save!
    @proposal.add_vote(v)
    (t-1).should == @proposal.score
  end
  
  it "should increment the score by one when a negative vote is removed" do
    t = @proposal.score
    v = Vote.new
    v.attributes = {:account_id=>1, :proposal_id=>@proposal.id, :character_id=>1, :user_id=>1, :value=>-1}
    v.save!
    @proposal.remove_vote(v)
    (t+1).should == @proposal.score
  end
  
  it "should correctly register a new positive vote when no other votes exist" do
    a = Account.find(:last)
    a.validated = true
    a.character = Character.find(642510006)
    a.save!
    @proposal.vote!(a.id, 1)
    @proposal.score.should == 1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == 1
  end
  
  it "should correctly register a new negative vote when no other votes exist" do
    a = Account.find(:first)
    a.validated = true
    a.character = Character.find(642510006)
    a.save!
    @proposal.vote!(a.id, -1)
    @proposal.score.should == -1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == -1
  end
  
  it "should correctly update an existing positive vote to a negative vote" do
    a = Account.find(:first)
    a.validated = true
    a.character = Character.find(642510006)
    a.save!
    @proposal.vote!(a.id, 1)
    @proposal.vote!(a.id, -1)
    @proposal.score.should == -1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == -1
  end
  
  it "should correctly update an existing negative vote to a positive vote" do
    a = Account.find(:first)
    @proposal.vote!(a.id, -1)
    @proposal.vote!(a.id, 1)
    @proposal.score.should == 1
    @proposal.votes.length.should == 1
    @proposal.votes.first.account_id.should == a.id
    @proposal.votes.first.value.should == 1
  end
  
  it "should correctly remove an existing vote when passed a value of 0" do
    a = Account.find(:first)
    a.validated = true
    a.save!
    @proposal.vote!(a.id, 1)
    @proposal.vote!(a.id, 0)
    @proposal.score.should == 0
    @proposal.votes.length.should == 0
  end
  
  it "should add a disabled vote when passed an invalidated account" do
    @account = Account.find_by_api_uid(1)
    @proposal.vote!(@account.id,1)
    @proposal.votes.first.enabled.should == false
    @proposal.votes.first.value.should == 1
    @proposal.score.should == 0
    @proposal.votes.length.should == 1
  end
  
  it "should do nothing when passed a value of 0" do
    a = Account.find(:first)
    a.validated = true
    a.save!
    @proposal.vote!(a.id, 0)
    @proposal.score.should == 0
    @proposal.votes.length.should == 0
  end
  
end
