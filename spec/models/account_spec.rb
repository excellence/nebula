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
  describe "validating attributes" do
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
  
  describe "validating account data" do
    before(:each) do
      Reve::API.characters_url = XML_BASE + 'two_characters.xml'
      Reve::API.character_sheet_url = XML_BASE + 'character_sheet_valid.xml'
      Reve::API.corporation_sheet_url = XML_BASE + 'corporation_sheet.xml'
      Reve::API.alliances_url =  XML_BASE + 'alliance_list.xml'
      @account = Factory.create(:account)
    end
    
    it "should update the associated characters" do
      Reve::API.characters_url = XML_BASE + 'two_characters.xml'
      @account.update!
      @account.character.should == @account.characters.first
      @account.characters.first.skill_points.should == 9_607_843
      @account.validated.should == true
    end

    it "should auto-select the character if there is only one" do
      Reve::API.characters_url = XML_BASE + 'one_character.xml'
      @account.update!
      @account.character.should == @account.characters.first
    end

    describe "should be invalid" do
      it "given an invalid api key" do
        Reve::API.characters_url = 'http://api.eve-online.com/account/Characters.xml.aspx'
        Reve::API.character_sheet_url = 'http://api.eve-online.com/char/CharacterSheet.xml.aspx'
        @account.update!
        @account.validated.should == false
      end
      it "given a valid api key holding just one character with less then 3m skillpoints" do
        Reve::API.characters_url = XML_BASE + 'one_character.xml'
        Reve::API.character_sheet_url = XML_BASE + 'character_sheet_too_less_sp.xml'
        @account.update!
        @account.validated.should == false
      end
      it "given a valid api key and having selected a character with _less_ then 3m skillpoints" do
        Reve::API.character_sheet_url = XML_BASE + 'character_sheet_too_less_sp.xml'
        @account.update!
        @account.select_character! @account.characters.first
        @account.validated.should == false
      end
      
      it "given a valid api key as third account" do
        Factory.create(:account, :api_uid => 2, :user_id => @account.user_id)
        Factory.create(:account, :api_uid => 3, :user_id => @account.user_id)
        Reve::API.characters_url = XML_BASE + 'one_character.xml'
        @account.update!
        @account.validated.should == false
      end
      it "given a valid api key but its user has registered under the same ip as another user" do
        Factory.create(:user, :email => 'userfive@test.evenebula.org')
        Reve::API.characters_url = XML_BASE + 'one_character.xml'
        @account.update!
        @account.validated == false
      end
    end
    describe "should be valid" do
      it "given a valid api key holding just one character with more then 3m skillpoints" do
        Reve::API.characters_url = XML_BASE + 'one_character.xml'
        @account.update!
        @account.characters.length.should == 1
        @account.character.should == @account.characters.first
        @account.characters.first.skill_points.should == 9_607_843
        @account.validated.should == true
      end
      it "given a valid api key and having selected a character with more then 3m skillpoints" do
        @account.update!
        @account.select_character! @account.characters.first
        @account.validated.should == true
      end
      it "given a valid api key and has been validated manually" do
        pending
      end
    end
  
  end
  
end
