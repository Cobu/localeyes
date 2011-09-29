require 'spec_helper'

describe "Consumer User" do
  let(:user) { User.make!(:dude) }
  let(:business_user) { BusinessUser.make!(:email=>"dude@dude.com") }
  let(:cafe) {
    cafe = Business.make(:oswego_cafe, :user=> business_user)
    cafe.set_default_hours
    cafe.save
    cafe
  }
  let(:resto) {
    resto = Business.make(:oswego_restaurant, :user=> business_user)
    resto.set_default_hours
    resto.save
    resto
  }
  let(:now) { Time.now.utc }

  def sign_in_user(user)
    ApplicationController.session_data = {:user_id=>user.id}
  end

  it "can autocomplete search locations", :js =>true, :driver=>:selenium_chrome do
    College.make!(:suny_oswego)

    sign_in_user(user)
    visit consumers_path

    fill_in "search_location", :with=> 'Suny'
    find(:css, '.ui-menu-item .ui-corner-all:contains("SUNY College at Oswego Oswego, NY 13126")').should be_present
  end

  describe "logged in" do

    before(:each) do
      sign_in_user(user)
      visit consumers_path
    end


    it "can see events", :js =>true, :driver=>:selenium_chrome do
      ZipCode.make!(:oswego)
      Event.make!(:once,
                  :business=>cafe,
                  :start_time => now.change(:hour =>now.hour - 1, :min => 0, :sec => 0),
                  :end_time => now.change(:hour =>now.hour + 1, :min => 0, :sec => 0),
                  :title=>"one times")
      #Event.make(:daily, :business=>cafe, :start_time => Time.utc(2011, now.month, 5, 7, 30), :title=>"fun day times")
      #Event.make(:weekly, :business=>cafe, :start_time => Time.utc(2011, now.month, 6, 21, 30), :end_time => Time.utc(2011, now.month, 7, 1, 50), :title=>"bubbly times")

      fill_in "search_location", :with=> 'Oswego'
      find(:css, '.ui-menu-item .ui-corner-all:contains("Oswego, NY 13126")').click

      page.has_content?("Public Library Cafe").should be_true

      find(:css, '.event .info').click
    end

  end
  end
