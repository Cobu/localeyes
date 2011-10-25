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

    it "can see events", :js =>true do
      ZipCode.make!(:oswego)

      utc_offset_hours = Time.now.utc_offset / 3600

      p Event.make!(:once,
                  :business=>cafe,
                  :start_time => now.change(:min => 0, :sec => 0).advance(:hours => utc_offset_hours + 1),
                  :end_time => now.change(:min => 0, :sec => 0).advance(:hours => utc_offset_hours + 2),
                  :title=>"one times")

      fill_in "search_location", :with=> 'Oswego'

      find(:css, '.ui-menu-item .ui-corner-all:contains("Oswego, NY 13126")').click

      page.has_content?("Public Library Cafe").should be_true

      find(:css, '.event .info').click
    end

  end
  end
