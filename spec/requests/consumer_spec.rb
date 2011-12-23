require 'spec_helper'

describe ConsumersController do
  let(:user) { User.make!(:dude) }
  let(:business_user) { BusinessUser.make! }
  let(:cafe) { Business.make(:oswego_cafe, :user=> business_user) }
  let(:resto) { Business.make(:oswego_restaurant, :user=> business_user) }
  let(:now) { Time.now.utc }

  #context "#home" do
  #  it "works" do
  #    p [1,cookies]
  #    p methods.sort
  #    #session[:dude]= 1
  #    visit home_consumers_path
  #    #p page.body
  #  end
  #end

  describe "#event_list" do

    before do
      College.make!(:suny_oswego)
      ZipCode.make!(:oswego)
      visit event_list_consumers_path
    end

    describe "logged in" do

      it "can autocomplete search locations" do
        login_user(user)
        fill_in "location_search", :with=> 'Suny'
        find(:css, '.ui-menu-item .ui-corner-all:contains("SUNY College at Oswego Oswego, NY 13126")').should be_present
      end

      it "can see events and business details", :js =>true do
        utc_offset_hours = Time.now.utc_offset / 3600

        Event.make!(:once,
                    :business=>cafe,
                    :start_time => now.change(:min => 0, :sec => 0).advance(:hours => utc_offset_hours + 1),
                    :end_time => now.change(:min => 0, :sec => 0).advance(:hours => utc_offset_hours + 2),
                    :title=>"one times")

        fill_in "location_search", :with=> 'Oswego'

        find(:css, '.ui-menu-item .ui-corner-all:contains("Oswego, NY 13126")').click

        page.has_content?("Public Library Cafe").should be_true

        find(:css, '.event .info').click

        page.has_content?("Public Library Cafe").should be_true
      end
    end
  end
end
