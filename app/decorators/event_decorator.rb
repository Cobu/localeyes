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

end