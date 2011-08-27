require "spec_helper"

describe EventsController do

  describe "#destroy" do

    before(:each) do
      @cafe = Business.make(:nyc_cafe)
    end

    it "recurring event on one date in series sets an exclusion date for this one date" do
      @event = Event.make(:daily, :businesses=>@cafe)

      put :destroy, :id =>@event.id, :edit_affects_type=>'one',
          :edit_start_time=> (@event.start_time + 1.day), :start_end_date_diff => 0

      event = Event.find(@event.id)

      event.schedule.occurs_on?(@event.start_time + 1.day).should be_false
      event.occurrences_between(@event.start_time, (@event.start_time + 2.days)).size.should==2
    end

    it "recurring event all in series removes event" do
      @event = Event.make(:daily, :businesses=>@cafe)

      put :destroy, :id =>@event.id, :edit_affects_type=>'all_series'
      Event.where(@event.id).first.should be_nil
    end

    it "one time event removes event" do
      @event = Event.make(:once, :businesses=>@cafe)
      put :destroy, :id =>@event.id, :edit_affects_type=>''
      Event.where(@event.id).first.should be_nil
    end

  end

  describe "#create" do
    before(:each) do
      @cafe = Business.make(:nyc_cafe)
      Event.destroy_all
    end

    it "creates one time event" do
      title = "mooooooo"
      description = "juice"
      event_type = Event::ANNOUNCEMENT
      recur_value = Event::ONCE

      event = {
              :recur_value=>recur_value, :title=>title, :description=>description, :event_type=> event_type,
              :start_date=> "07/01/2011", :start_time_hour=> "10", :start_time_minute=>"41", :start_time_am_pm=>"am",
              :end_date=> "07/01/2011", :end_time_hour=> "01", :end_time_minute=>"30", :end_time_am_pm=>"pm",
      }

      put :create, :event=> event, :edit_affects_type=>"", :edit_start_time=>"", :start_end_date_diff=>"0"
      e = Event.first
      e.start_time.should == Time.utc(2011,7,1,10,41,0)
      e.end_time.should == Time.utc(2011,7,1,13,30,0)
    end
  end

  context "#update single date" do

    before(:each) do
      @cafe = Business.make(:nyc_cafe)
      @event = Event.make(:once,
                          :businesses=>@cafe,
                          :start_time=>Time.utc(2011, 7, 1, 2, 40, 0),
                          :end_time=>Time.utc(2011, 7, 1, 2, 50, 0)
      )
    end

    it "changeing the title , event type and description" do
      new_title = "mooooooo"
      new_description = "juice"
      new_event_type = Event::ANNOUNCEMENT
      new_start_time = @event.start_time.advance(:hours=> 8, :minutes=> 1)
      new_end_time = @event.end_time.advance(:hours=> 11, :minutes=> -20)

      event = {
              :event_type=>new_event_type, :title=>new_title, :description=>new_description,
              :start_date=> "07/01/2011", :start_time_hour=> "10", :start_time_minute=>"41", :start_time_am_pm=>"am",
              :end_date=> "07/01/2011", :end_time_hour=> "01", :end_time_minute=>"30", :end_time_am_pm=>"pm",
      }


      put :update, :id =>@event.id, :event=> event, :edit_affects_type=>'all_series'

      event = Event.find(@event.id)

      event.title.should == new_title
      event.description.should == new_description
      event.event_type.should == new_event_type
      event.start_time.should == new_start_time
      event.end_time.should == new_end_time
    end

  end

  context "#update recurring" do

    before(:each) do
      @cafe = Business.make(:nyc_cafe)
      @event = Event.make(:daily,
                          :businesses=>@cafe,
                          :start_time=>Time.utc(2011, 7, 1, 2, 40, 0),
                          :end_time=>Time.utc(2011, 7, 1, 2, 50, 0)
      )
    end

    context "all series" do

      it "changeing the title , event type and description" do
        new_title = "mooooooo"
        new_description = "juice"
        new_event_type = Event::ANNOUNCEMENT

        event = {
                :event_type=>new_event_type, :title=>new_title, :description=>new_description
        }


        put :update, :id =>@event.id, :event=> event, :edit_affects_type=>'all_series'

        event = Event.find(@event.id)

        event.title.should == new_title
        event.description.should == new_description
        event.event_type.should == new_event_type
      end

      it "NOT changing the recur until date" do
        event = {
                "recur_until_date"=>"never", "recur_value"=>"day"
        }

        put :update, :id =>@event.id, :event=> event, :edit_affects_type=>'all_series'
        event = Event.find(@event.id)

        event.schedule.rrules.count.should == 1
        event.schedule.rrules.first.to_s.should == 'Daily'
        event.schedule.rrules.first.until_date.should == nil
      end

      it "changing the recur until date" do
        until_date = (@event.start_time + 1.day).to_date

        event = {
                "recur_until_date"=>until_date.strftime("%m/%d/%Y"), "recur_value"=>"day"
        }

        put :update, :id =>@event.id, :event=> event, :edit_affects_type=>'all_series'
        event = Event.find(@event.id)

        event.schedule.rrules.count.should == 1
        event.schedule.rrules.first.to_s.should == 'Daily'
        event.schedule.rrules.first.until_date.should == until_date
        occurrences = event.occurrences_between(@event.start_time, (@event.start_time + 2.days))
        occurrences.size.should == 1
      end
    end

    context "one date" do
      it "sets an exclusion date for this one date and makes new event" do

        new_title = "mooooooo"

        event = {
                :title=> new_title,
        }

        put :update, :id =>@event.id, :event=> event, :edit_affects_type=>'one',
            :edit_start_time=> (@event.start_time + 1.day), :start_end_date_diff => 0

        event = Event.find(@event.id)

        event.schedule.occurs_on?(@event.start_time + 1.day).should be_false
        event.occurrences_between(@event.start_time, (@event.start_time + 2.days)).size.should==2
        event.title.should_not == new_title

        new_event = Event.where(:start_time=>@event.start_time + 1.day).first
        new_event.end_time.should == @event.end_time + 1.day
        new_event.schedule.start_date.should == new_event.start_time
        new_event.title.should == new_title
      end
    end
  end

end
