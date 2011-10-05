class Event < ActiveRecord::Base
  belongs_to :business

  serialize :schedule, IceCube::Schedule

  before_update  :edit_schedule
  before_update  :set_time_attributes, :if => :one_time_event?
  before_create  :set_time_attributes, :create_schedule

  EVENT = 0
  SPECIAL = 1
  ANNOUNCEMENT = 2
  EVENT_TYPES = [EVENT, SPECIAL, ANNOUNCEMENT]
  EVENT_NAMES = {EVENT=>'event', SPECIAL=> 'special', ANNOUNCEMENT=> 'announcement'}

  ONCE = 'once'
  DAILY = 'day'
  WEEKLY = 'week'
  MONTHLY = 'month'
  RECUR_TYPES = [ONCE,DAILY,WEEKLY,MONTHLY]

  attr_writer :start_date, :start_time_hour, :start_time_minute, :start_time_am_pm,
              :end_date, :end_time_hour, :end_time_minute, :end_time_am_pm,
              :recur_value, :recur_until_date, :edit_affects

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

  def recurring?
    schedule.present?
  end

  def recur_value
    return ONCE unless schedule && schedule.rrules.any?
    schedule_attributes.interval_unit
  end

  def one_time_event?
    recur_value == ONCE
  end

  def recur_until_date
    schedule_attributes.until_date
  end

  def business_events(start_date, end_date)
    occurrences_between(start_date, end_date).collect { |date| business_event_details(date) }
  end

  def consumer_events(start_date, end_date)
    occurrences_between(start_date, end_date).collect { |date| consumer_event_details(date) }
  end

  def occurrences_between(start_date, end_date)
    start_date = start_date.to_time if start_date.is_a?(Date)
    end_date = end_date.to_time if end_date.is_a?(Date)
    if schedule and schedule.rrules.any?
      schedule.occurrences_between(start_date, end_date)
    else
      if (start_date - self.end_time) * (self.start_time - end_date) >= 0
        [start_time]
      else
        []
      end
    end
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
      :service_type => "#{EVENT_NAMES[event_type]}_type",
    }
  end

  def adjusted_times(date)
    starttime = date.to_time.utc.change(:hour => start_time.hour, :min => start_time.min, :sec => 0)
    endtime = date.to_time.utc.advance(:days=>start_end_date_diff).change(:hour => end_time.hour, :min => end_time.min, :sec => 0)
    return starttime, endtime
  end

  def business_event_details(date=start_time)
    starttime, endtime = adjusted_times(date)
    {
      :id=> to_param,
      :title=> title,
      :start => starttime,
      :end => endtime,
      :allDay => false, # will make the time show
      :url => Rails.application.routes.url_helpers.edit_event_path(id),
      :className => "#{EVENT_NAMES[event_type]}_type",
    }
  end

  def start_end_date_diff
    (end_time.to_date - start_time.to_date).to_i
  end

  def set_time_attributes
    if @start_date && @start_time_hour && @start_time_minute && @start_time_am_pm
      write_attribute(:start_time,
         DateTime.strptime("#{@start_date} #{@start_time_hour}:#{@start_time_minute} #{@start_time_am_pm}","%m/%d/%Y %I:%M %p")
      )
    end

    if @end_date && @end_time_hour && @end_time_minute && @end_time_am_pm
      write_attribute(:end_time,
         DateTime.strptime("#{@end_date} #{@end_time_hour}:#{@end_time_minute} #{@end_time_am_pm}","%m/%d/%Y %I:%M %p")
      )
    end
    true
  end

  def create_schedule
    if (RECUR_TYPES-[ONCE]).include? @recur_value
      schedule = IceCube::Schedule.new(start_time)
      rule = case @recur_value
        when 'day'
          IceCube::Rule.daily
        when 'week'
          IceCube::Rule.weekly
        when 'month'
          IceCube::Rule.monthly
      end
      until_date = Time.strptime(@recur_until_date,"%m/%d/%Y") rescue nil
      rule.until(until_date)
      schedule.add_recurrence_rule(rule)
      self.schedule = schedule
    end
    true
  end

  def edit_schedule
    if schedule and schedule.rrules.any? and @recur_until_date
      rule = schedule.rrules.first
      until_date = Time.strptime(@recur_until_date,"%m/%d/%Y") rescue nil
      rule.until(until_date)
    end
    true
  end

  def add_exception_date(start_time)
    schedule.add_exception_date(start_time)
  end

  def schedule_attributes
    atts = {}

    if rule = schedule && schedule.rrules.first
      case rule
        when IceCube::DailyRule
          atts[:interval_unit] = 'day'
        when IceCube::WeeklyRule
          atts[:interval_unit] = 'week'
        when IceCube::MonthlyRule
          atts[:interval_unit] = 'month'
      end
      if rule.until_date
        atts[:until_date] = rule.until_date.to_date.strftime("%m/%d/%Y")
        atts[:ends] = 'eventually'
      else
        atts[:ends] = 'never'
      end
    end

    OpenStruct.new(atts)
  end
end