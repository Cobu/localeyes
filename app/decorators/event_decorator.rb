class EventDecorator < ApplicationDecorator
  decorates :event

  # a string representation that parses with Time.parse(str) in ruby
  def start_time_str
    start_time.strftime("%Y-%m-%d %I:%M %P")
  end

  def start_date
    start_time.strftime("%m/%d/%Y")
  end

  def start_time_hour
    start_time.strftime("%I")
  end

  def start_time_minute
    start_time.strftime("%M")
  end

  def start_time_am_pm
    start_time.strftime("%P")
  end

  def end_date
    end_time.strftime("%m/%d/%Y")
  end

  def end_time_hour
    end_time.strftime("%I")
  end

  def end_time_minute
    end_time.strftime("%M")
  end

  def end_time_am_pm
    end_time.strftime("%P")
  end

  def adjusted_times(date)
    starttime = date.to_time.utc.change(:hour => start_time.hour, :min => start_time.min, :sec => 0)
    endtime = date.to_time.utc.advance(:days=>start_end_date_diff).change(:hour => end_time.hour, :min => end_time.min, :sec => 0)
    return starttime, endtime
  end

  def start_end_date_diff
    (end_time.to_date - start_time.to_date).to_i
  end

  def business_events(start_date, end_date)
    occurrences_between(start_date, end_date).collect { |date| business_event_details(date) }
  end

  def consumer_events(start_date, end_date)
    occurrences_between(start_date, end_date).collect { |date| consumer_event_details(date) }
  end

  def business_event_details(date=start_time)
    starttime, endtime = adjusted_times(date)
    {
      :id=> to_param,
      :title=> title,
      :start => starttime.iso8601,
      :end => endtime.iso8601,
      :allDay => false, # will make the time show
      :url => Rails.application.routes.url_helpers.edit_event_path(id),
      :className => "#{model.class::EVENT_NAMES[event_type]}_type",
    }
  end

  def consumer_event_details(date=start_time)
    starttime, endtime = adjusted_times(date)
    {
      :id=> to_param,
      :title=> title,
      :description=> description,
      :start => starttime.strftime('%Y-%m-%d %H:%M:%S'),
      :end => endtime,
      :business_id => business_id,
      :service_type => "#{model.class::EVENT_NAMES[event_type]}_type",
    }
  end
end