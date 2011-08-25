require 'spec_helper'

describe Event do

  context "one day" do

    before(:each) do
      @b = Business.make(:nyc_restaurant)
      @e = Event.make(:once, :business=> @b)
    end

    it "makes event with schedule" do
      @e.occurrences_between(@e.start_time, (@e.start_time + 2.days)).size.should==1
    end

    it "makes event details" do
      @e.calendar_detail.should == {
              :id=>@e.to_param,
              :title=>"one times",
              :start=>Time.utc(2011, 8, 5, 7, 30),
              :end=>Time.utc(2011, 8, 5, 9, 30),
              :allDay=>false,
              :url=>"/events/#{@e.id}/edit"
      }
    end

    it "makes event details for event spanning two days and at night" do
      @e = Event.make(:once, :start_time => Time.utc(2011,8,3,23,00), :end_time => Time.utc(2011,8,4,1,30), :business=>@b)

      @e.calendar_detail.should == {
              :id=>@e.to_param,
              :title=>"one times",
              :start=>Time.utc(2011, 8, 3, 23, 00),
              :end=>Time.utc(2011, 8, 4, 1, 30),
              :allDay=>false,
              :url=>"/events/#{@e.id}/edit"
      }
    end
  end

  context "daily" do

    before(:each) do
      @b = Business.make(:nyc_restaurant)
      @e = Event.make(:daily, :business=> @b)
    end


    it "makes event with schedule" do
       @e.schedule.occurrences_between(@e.start_time, @e.start_time+1.day).size.should == 2
       @e.occurrences_between(@e.start_time, (@e.start_time + 2.days)).size.should==3
    end

    it "#occurrences_between" do
      @e = Event.make(:once, :business=> @b)
      @e.occurrences_between(@e.start_time, @e.start_time+1.day).size.should == 1
    end

    it "makes event details" do
      @e.calendar_detail.should == {
              :id=>@e.to_param,
              :title=>"say hi to rob and then go home",
              :start=>Time.utc(2011, 8, 5, 7, 30),
              :end=>Time.utc(2011, 8, 5, 9, 30),
              :allDay=>false,
              :url=>"/events/#{@e.id}/edit"
      }

      @e.calendar_detail(@e.start_time+1.day).should == {
              :id=>@e.to_param,
              :title=>"say hi to rob and then go home",
              :start=>Time.utc(2011, 8, 6, 7, 30),
              :end=>Time.utc(2011, 8, 6, 9, 30),
              :allDay=>false,
              :url=>"/events/#{@e.id}/edit"
      }
    end

  end

end
