require 'spec_helper'

describe EventDecorator do
  let(:start_time) { Time.utc(2011, 8, 5, 7, 30) }
  let(:end_time) { Time.utc(2011, 8, 5, 9, 30) }

  before(:all) do
    @once_event =
      build(:once_event,
            :business => build(:business),
            :start_time => start_time,
            :end_time => end_time
      ) { |e| e.id = 1 }
  end

  context 'date methods' do
    subject { EventDecorator.new(@once_event) }

    its(:start_time_str) { should == "2011-08-05 07:30 am" }
    its(:start_date) { should == "08/05/2011" }
    its(:start_time_hour) { should == "07" }
    its(:start_time_minute) { should == "30" }
    its(:start_time_am_pm) { should == "am" }
    its(:end_date) { should == "08/05/2011" }
    its(:end_time_hour) { should == "09" }
    its(:end_time_minute) { should == "30" }
    its(:end_time_am_pm) { should == "am" }
  end

  describe 'business_event_details' do

    it 'for once event' do
      event = EventDecorator.new(@once_event)

      event.business_event_details.should == {
        :id => @once_event.to_param,
        :title => "one times",
        :start => start_time.iso8601,
        :end => end_time.iso8601,
        :allDay => false,
        :url => "/events/#{@once_event.id}/edit",
        :className => 'event_type'
      }
    end

    it 'for once event spanning two days and at night' do
      event = build(:once_event,
                    :business => build(:business),
                    :start_time => Time.utc(2011, 8, 3, 23, 00),
                    :end_time => Time.utc(2011, 8, 4, 1, 30)
      ) { |e| e.id = 1 }
      event = EventDecorator.new(event)

      event.business_event_details.should == {
        :id => event.to_param,
        :title => "one times",
        :start => Time.utc(2011, 8, 3, 23, 00).iso8601,
        :end => Time.utc(2011, 8, 4, 1, 30).iso8601,
        :allDay => false,
        :url => "/events/#{event.id}/edit",
        :className => 'event_type'
      }
    end

    context 'daily event' do
      let(:event) do
        build(:daily_event,
              start_time: start_time,
              end_time: end_time) { |e| e.id = 1 }
      end

      let(:decorated_event) { EventDecorator.new(event) }

      it 'for first date' do
        decorated_event.business_event_details.should == {
          :id => event.to_param,
          :title => "daily times",
          :start => start_time.iso8601,
          :end => end_time.iso8601,
          :allDay => false,
          :url => "/events/#{event.id}/edit",
          :className => 'event_type'
        }
      end

      it 'another date' do
        decorated_event.business_event_details(event.start_time+1.day).should == {
          :id => event.to_param,
          :title => "daily times",
          :start => (start_time+1.day).iso8601,
          :end => (end_time+1.day).iso8601,
          :allDay => false,
          :url => "/events/#{event.id}/edit",
          :className => 'event_type'
        }
      end
    end

  end
end