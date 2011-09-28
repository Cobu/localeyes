require 'spec_helper'

describe Event do

  let(:business) { Business.make(:oswego_restaurant) }

  describe "one day" do

    let(:event) do
      event = Event.make(:once,
                         :business => business,
                         :start_time => Time.utc(2011, 8, 5, 7, 30),
                         :end_time => Time.utc(2011, 8, 5, 9, 30)
      )
      event.id = 1
      event
    end

    it "can save and load" do
      business.save
      event.save
      Event.first
    end

    describe "#occurrences_between" do
      it "start time, end time that are dates instead of times" do
        event.occurrences_between(event.start_time.to_date, event.end_time.to_date+1.day).size.should== 1
        event.occurrences_between(event.start_time.to_date-1.day, event.end_time.to_date).size.should== 0
      end

      it "start time, end time that are before search time range" do
        event.occurrences_between(event.end_time + 1.second, (event.end_time + 2.days)).size.should== 0
      end

      it "start time, end time that are after search time range" do
        event.occurrences_between(event.start_time - 1.day, (event.start_time - 1.second)).size.should== 0
      end

      it "start time, end time that are within time range" do
        event.occurrences_between(event.start_time - 1.hour, (event.start_time + 1.hour)).size.should== 1
      end
    end

    it "#business_event_details" do
      event.business_event_details.should == {
              :id=> event.to_param,
              :title=> "one times",
              :start=> Time.utc(2011, 8, 5, 7, 30),
              :end=> Time.utc(2011, 8, 5, 9, 30),
              :allDay=> false,
              :url=> "/events/#{event.id}/edit",
              :className=> 'event_type'
      }
    end

    it "#business_event_details for event spanning two days and at night" do
      event.start_time = Time.utc(2011, 8, 3, 23, 00)
      event.end_time = Time.utc(2011, 8, 4, 1, 30)

      event.business_event_details.should == {
              :id=>event.to_param,
              :title=>"one times",
              :start=>Time.utc(2011, 8, 3, 23, 00),
              :end=>Time.utc(2011, 8, 4, 1, 30),
              :allDay=>false,
              :url=>"/events/#{event.id}/edit",
              :className=> 'event_type'
      }
    end
  end

  describe "daily" do

    let(:event) do
      event = Event.make(:daily,
                         :business => business,
                         :start_time => Time.utc(2011, 8, 5, 7, 30),
                         :end_time => Time.utc(2011, 8, 5, 9, 30)
      )
      event.id = 1
      event.create_schedule
      event
    end

    it "can save and load" do
      business.save
      event.save
      Event.first.schedule
    end

    it "makes event with schedule" do
      event.schedule.occurrences_between(event.start_time, event.start_time+1.day).size.should == 2
      event.occurrences_between(event.start_time, (event.start_time + 2.days)).size.should==3
    end

    it "#occurrences_between" do
      event.occurrences_between(event.start_time, event.start_time+1.hour).size.should == 1
      event.occurrences_between(event.start_time, event.start_time+1.day).size.should == 2
    end

    it "#business_event_details" do
      event.business_event_details.should == {
              :id=>event.to_param,
              :title=>"say hi to rob and then go home",
              :start=>Time.utc(2011, 8, 5, 7, 30),
              :end=>Time.utc(2011, 8, 5, 9, 30),
              :allDay=>false,
              :url=>"/events/#{event.id}/edit",
              :className=> 'event_type'
      }

      event.business_event_details(event.start_time+1.day).should == {
              :id=>event.to_param,
              :title=>"say hi to rob and then go home",
              :start=>Time.utc(2011, 8, 6, 7, 30),
              :end=>Time.utc(2011, 8, 6, 9, 30),
              :allDay=>false,
              :url=>"/events/#{event.id}/edit",
              :className=> 'event_type'
      }
    end

    it "can set until date on new schedule" do
      until_date = Date.today.to_time
      event = Event.make(:daily,
                         :recur_until_date => until_date.strftime("%m/%d/%Y"),
                         :start_time => Time.utc(2011, 8, 5, 7, 30),
                         :end_time => Time.utc(2011, 8, 5, 9, 30)
      )
      event.create_schedule
      event.schedule.rrules.first.until_date.class.should == Time
      event.schedule.rrules.first.until_date.should == until_date
    end

    it "can update until date on existing schedule" do
      until_date = Date.today.to_time
      event = Event.make(:daily,
                         :start_time => Time.utc(2011, 8, 5, 7, 30),
                         :end_time => Time.utc(2011, 8, 5, 9, 30)
      )
      event.create_schedule
      event.schedule.rrules.first.until_date.should == nil
      event.recur_until_date = until_date.strftime("%m/%d/%Y")
      event.edit_schedule
      event.schedule.rrules.first.until_date.should == until_date
    end

  end
end

