class Event < ActiveRecord::Base
  belongs_to :business

  before_save :limit_title
  before_update :edit_schedule
  before_update :set_time_attributes, :if => :one_time_event?
  before_create :set_time_attributes, :create_schedule
  after_create :init_event_vote

  EVENT = 0
  SPECIAL = 1
  ANNOUNCEMENT = 2
  EVENT_TYPES = [EVENT, SPECIAL, ANNOUNCEMENT]
  EVENT_NAMES = {EVENT => 'event', SPECIAL => 'special', ANNOUNCEMENT => 'announcement'}

  ONCE = 'once'
  DAILY = 'day'
  WEEKLY = 'week'
  MONTHLY = 'month'
  RECUR_TYPES = [ONCE, DAILY, WEEKLY, MONTHLY]

  serialize :schedule, IceCube::Schedule

  attr_writer :start_date, :start_time_hour, :start_time_minute, :start_time_am_pm,
              :end_date, :end_time_hour, :end_time_minute, :end_time_am_pm,
              :recur_value, :edit_affects

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

  def recur_until_date=(date)
    @recur_until_date =
      case date
        when String then
          DateTime.strptime(date, "%m/%d/%Y").to_time rescue nil
        when Date then
          date.to_time
        when Time then
          date
        else
          nil
      end
  end

  def recur_until_date
    schedule_attributes.until_date
  end

  def occurs_between?(start_date, end_date)
    start_date = start_date.to_time if start_date.is_a?(Date)
    end_date = end_date.to_time if end_date.is_a?(Date)
    if schedule and schedule.rrules.any?
      schedule.occurs_between?(start_date, end_date)
    else
      (start_date - self.end_time) * (self.start_time - end_date) >= 0
    end
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

  def occurs_on?(date)
    return schedule.occurs_on?(date) if schedule
    date == start_time.to_date
  end
  alias :occurs? :occurs_on?

  def set_time_attributes
    if @start_date && @start_time_hour && @start_time_minute && @start_time_am_pm
      write_attribute(:start_time,
                      DateTime.strptime("#{@start_date} #{@start_time_hour}:#{@start_time_minute} #{@start_time_am_pm}", "%m/%d/%Y %I:%M %p")
      )
    end

    if @end_date && @end_time_hour && @end_time_minute && @end_time_am_pm
      write_attribute(:end_time,
                      DateTime.strptime("#{@end_date} #{@end_time_hour}:#{@end_time_minute} #{@end_time_am_pm}", "%m/%d/%Y %I:%M %p")
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

      rule.until(@recur_until_date) if @recur_until_date
      schedule.add_recurrence_rule(rule)

      self.schedule = schedule
    end
    true
  end

  def edit_schedule
    if schedule and schedule.rrules.any? and @recur_until_date
      rule = schedule.rrules.first
      rule.until(@recur_until_date)
    end
    true
  end

  def add_exception_time(start_time)
    schedule.add_exception_time(start_time)
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
      if rule.until_time
        atts[:until_time] = rule.until_time.to_date.strftime("%m/%d/%Y")
        atts[:ends] = 'eventually'
      else
        atts[:ends] = 'never'
      end
    end

    OpenStruct.new(atts)
  end

  def limit_title
    self.title = title.slice(0, 34)
  end

  def init_event_vote
    EventVote.setup(id)
  end

  def self.publish
    p "Daily Publish going through #{Event.all.size} events"
    today = Date.today
    Event.all.each { |event| event.publish if event.occurs?(today) }
  end
end