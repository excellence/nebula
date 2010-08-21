require 'spec_helper'

describe "/accounts/show" do
  before(:each) do
    render 'accounts/show'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/accounts/show])
  end
end
