require 'spec_helper'

describe ConsumersController do
  let(:user) { create(:user) }
  let(:business_user) { create(:business_user) }
  let(:cafe) { build(:oswego_cafe, :user=> business_user) }
  let(:resto) { build(:oswego_restaurant, :user=> business_user) }
  let(:now) { Time.now.utc }

  describe "#event_list" do
    let(:town) { create(:oswego) }
    let(:college) { create(:suny_oswego) }
    let(:cafe) { create(:oswego_cafe) }

    before do
      college
      town
    end

    describe "returns correct event list" do

      # NOTE: very important, the way i set now time is the way controller sets it
      let(:now) { Time.zone.at(Time.now.to_i) }

      describe "when dates are removed from series" do
        before {
          event = create(:daily_event,
                         start_time: now.advance(seconds: 1),
                         # TODO .. fix this .. pass in date .. not string
                         recur_until_date: (now + 3.days).strftime("%m/%d/%Y"),
                         business: cafe,
                         title: "daily times"
          )
          event.add_exception_time(event.start_time + 1.day)
          event.save
        }

        it "and NO time is specified " do
          visit events_consumers_path(d: college.id, format: :json)
          events = JSON.parse(page.text)['events']
          events.size.should == 2
        end

        it "and a time is specified " do
          visit events_consumers_path(d: college.id, time: now, format: :json)
          events = JSON.parse(page.text)['events']
          events.size.should == 2
        end
      end
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
