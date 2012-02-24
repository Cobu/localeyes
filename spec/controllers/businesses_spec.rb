require 'spec_helper'

describe BusinessesController do

  context '#events' do
    let(:user) { create(:business_user) }
    let(:business) { create(:oswego_restaurant, :user=>user) }
    #let(:daily_event) {create(:daily_event, :start_time=>Time.now.utc.change(:min=>15), :end_time=>Time.now+1.hour, :business=> business)}

    before { login_business_user(user, business) }

    def get_json
      search_date = @event.start_time.to_i
      get :events, start: search_date, end: search_date, format: :json
    end

    it 'returns json response for one day event' do
      @event = create(:once_event,
                      :start_time => Time.utc(2011, 8, 5, 7, 30),
                      :business=> business)
      get_json

      JSON.parse(response.body).should == [{
        'id'=> @event.id.to_s,
        'title'=> "one times",
        'start'=> @event.start_time.iso8601,
        'end'=> @event.end_time.iso8601,
        'allDay'=> false,
        'url'=> "/events/#{@event.id}/edit",
        'className'=> 'event_type'
      }]
    end

    it 'json response for event spanning two days and at night' do
      @event = create(:once_event,
                      :start_time => Time.utc(2011, 8, 5, 7, 30),
                      :end_time => Time.utc(2011, 8, 4, 1, 30),
                      :business=> business)
      get_json

      JSON.parse(response.body).should == [{
        'id'=> @event.id.to_s,
        'title'=> "one times",
        'start'=> @event.start_time.iso8601,
        'end'=> @event.end_time.iso8601,
        'allDay'=> false,
        'url'=> "/events/#{@event.id}/edit",
        'className'=> 'event_type'
      }]

    end

  end
end
