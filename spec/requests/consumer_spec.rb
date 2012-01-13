require 'spec_helper'

describe ConsumersController do
  let(:user) { create(:dude) }
  let(:business_user) { create(:business_user) }
  let(:cafe) { build(:oswego_cafe, :user=> business_user) }
  let(:resto) { build(:oswego_restaurant, :user=> business_user) }
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
    let(:college) { create(:suny_oswego) }
    let(:town) { create(:oswego) }

    before do
      college
      town
    end

    it "creates fixture" do
      visit event_list_consumers_path(college: college.id)
      save_fixture(page.body, 'event_list_page')
    end

    describe "logged in" do
      before { visit event_list_consumers_path }

      it "can autocomplete search locations", js: true do
        login_user(user)
        fill_in "location_search", :with=> 'Suny'
        sleep 0.5
        find(:css, '.ui-menu-item .ui-corner-all:contains("SUNY College at Oswego Oswego, NY 13126")').should be_present
      end

      it "can see events and business details", :js =>true do
        create(:once_event,
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
