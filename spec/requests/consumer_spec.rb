require 'spec_helper'

describe "Consumer User" do
  let(:user) { User.make(:dude) }

  def sign_in_user(user)
    ApplicationController.session_data = { :user_id=>user.id }
  end

  describe "logged in" do

    before(:each) do
      sign_in_user(user)
      visit consumers_path
    end

    it "can autocomplete search locations", :js =>true, :driver=>:selenium_chrome  do
      College.make(:suny_oswego)
      fill_in "search_location", :with=> 'Suny'
      find(:css, '.ui-menu-item .ui-corner-all:contains("SUNY College at Oswego Oswego, NY 13126")').click
    end

  end
end
