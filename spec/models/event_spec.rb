require 'spec_helper'

describe Event do

  let(:business) { build(:oswego_restaurant) }

  it "can limit title to 34 chars" do
    event = create(:once_event, title: ('e'*35), business: business)
    event.title.should == ('e'*34)
  end

  describe "one day" do

    let(:event) do
      event = build(:once_event,
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

    #it "#business_event_details" do
    #  event.business_event_details.should == {
    #    :id=> event.to_param,
    #    :title=> "one times",
    #    :start=> Time.utc(2011, 8, 5, 7, 30),
    #    :end=> Time.utc(2011, 8, 5, 9, 30),
    #    :allDay=> false,
    #    :url=> "/events/#{event.id}/edit",
    #    :className=> 'event_type'
    #  }
    #end
    #
    #it "#business_event_details for event spanning two days and at night" do
    #  event.start_time = Time.utc(2011, 8, 3, 23, 00)
    #  event.end_time = Time.utc(2011, 8, 4, 1, 30)
    #
    #  event.business_event_details.should == {
    #    :id=>event.to_param,
    #    :title=>"one times",
    #    :start=>Time.utc(2011, 8, 3, 23, 00),
    #    :end=>Time.utc(2011, 8, 4, 1, 30),
    #    :allDay=>false,
    #    :url=>"/events/#{event.id}/edit",
    #    :className=> 'event_type'
    #  }
    #end
  end

  describe "daily" do

    let(:event) do
      event = build(:daily_event,
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

    #it "#business_event_details" do
    #  event.business_event_details.should == {
    #    :id=>event.to_param,
    #    :title=>"daily times",
    #    :start=>Time.utc(2011, 8, 5, 7, 30),
    #    :end=>Time.utc(2011, 8, 5, 9, 30),
    #    :allDay=>false,
    #    :url=>"/events/#{event.id}/edit",
    #    :className=> 'event_type'
    #  }
    #
    #  event.business_event_details(event.start_time+1.day).should == {
    #    :id=>event.to_param,
    #    :title=>"daily times",
    #    :start=>Time.utc(2011, 8, 6, 7, 30),
    #    :end=>Time.utc(2011, 8, 6, 9, 30),
    #    :allDay=>false,
    #    :url=>"/events/#{event.id}/edit",
    #    :className=> 'event_type'
    #  }
    #end

    describe "set until date on new schedule" do
      let(:event) {
        event = build(:daily_event, recur_until_date: @until_time)
        event.create_schedule
        event
      }

      it "with a date" do
        @until_time= Time.now.utc.to_date
        event.schedule.rrules.first.until_time.class.should == Time
      end

      it "with a string in m/d/y format" do
        @until_time = Time.now.utc.to_date.strftime('%m/%d/%Y')
        event.schedule.rrules.first.until_time.class.should == Time
      end

      it "with a time" do
        @until_time = Time.now.utc
        event.schedule.rrules.first.until_time.class.should == Time
      end
    end

    describe "can update until date on existing schedule" do
      let(:event) {
        event = build(:daily_event)
        event.create_schedule
        event
      }

      it "that has no until date to start" do
        event.schedule.rrules.first.until_time.should == nil
      end

      def check_recur_date(event, value)
        event.recur_until_date = value
        event.edit_schedule
        event.schedule.rrules.first.until_time.class.should == Time
      end

      it "with a date" do
        until_time = Time.now.utc.to_date
        check_recur_date event, until_time
      end

      it "with a time" do
        until_time = Time.now.utc
        check_recur_date event, until_time
      end

      it "with a string in m/d/y format" do
        until_time = Time.now.utc.to_date.strftime('%m/%d/%Y')
        check_recur_date event, until_time
      end
    end


    it "removes date from series" do
      remove_time = Time.utc(2011, 8, 5, 7, 30)
      event.schedule.occurrences(remove_time).size.should == 1
      event.add_exception_date(remove_time)
      event.schedule.occurrences(remove_time).size.should == 0
      event.occurrences_between(remove_time, remove_time).size.should == 0
    end

    it "removes two dates from series" do
      event.add_exception_date(Time.utc(2011, 8, 6, 7, 30))
      event.add_exception_date(Time.utc(2011, 8, 8, 7, 30))
      event.occurrences_between(Time.utc(2011, 8, 5, 4, 30),
                                Time.utc(2011, 8, 9, 17, 30)).size.should == 3
    end
  end

  describe "publish" do

    let(:yesterday_event) { build(:daily_event, business: business, start_time: Date.yesterday) }
    let(:today_event) { build(:daily_event, business: business, start_time: Date.today) }
    let(:tomorrow_event) { build(:daily_event,  business: business, start_time: Date.tomorrow) }

    before do
      Timecop.freeze(today_event.start_time)
      stub(Event).all { [yesterday_event, today_event, tomorrow_event] }
    end

    after { Timecop.return }

    it "publishes events when they are occurring on the current day" do
      mock(yesterday_event).publish.times(0)
      mock(today_event).publish
      mock(tomorrow_event).publish.times(0)
      Event.publish
    end
  end
end

