require 'spec_helper'

describe "Consumer User" do
  let(:user) { User.make!(:dude) }
  let(:business_user) { BusinessUser.make! }
  let(:cafe) { Business.make(:oswego_cafe, :user=> business_user) }
  let(:resto) { Business.make(:oswego_restaurant, :user=> business_user) }
  let(:now) { Time.now.utc }

  it "can autocomplete search locations", :js =>true do
    College.make!(:suny_oswego)

    login_user(user)
    visit consumers_path

    fill_in "search_location", :with=> 'Suny'
    find(:css, '.ui-menu-item .ui-corner-all:contains("SUNY College at Oswego Oswego, NY 13126")').should be_present
  end

  describe "logged in" do

    before(:each) do
      login_user(user)
      visit consumers_path
    end

    it "can see events", :js =>true do
      ZipCode.make!(:oswego)

      utc_offset_hours = Time.now.utc_offset / 3600

      Event.make!(:once,
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
