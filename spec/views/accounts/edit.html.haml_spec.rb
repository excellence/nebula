require 'spec_helper'

describe "/accounts/edit" do
  include Devise::TestHelpers
  before(:each) do
    @user = Factory.create(:user)
    sign_in @user
    @account = Factory.create(:account)
    render 'accounts/edit'
  end
  
end
