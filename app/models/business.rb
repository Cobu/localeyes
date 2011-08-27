class Business < ActiveRecord::Base
  belongs_to :user, :class_name => 'BusinessUser'
  has_many :events, :dependent => :destroy

  # day order is  [sun, mon, tues, wed , thu, fri, sat]
  # hours = [ [ :from=>time, :to=>time, :closed=>true], etc.. for each day starting with sunday ]
  # each hour is a time [ [time,time] ] to_yaml
  serialize :hours, Array
  attr_accessor :phone_first3, :phone_second3, :phone_last4

  after_initialize :set_default_hours, :if => :new_record?
  before_save :set_phone_number

  def set_default_hours
    nine_am = Time.utc(1970, 1, 1, 9, 00)
    five_pm = Time.utc(1970, 1, 1, 17, 00)
    6.times do |num|
      self.hours[num+1] = {:from=>nine_am, :to=>five_pm, :open=>true} # monday to saturday
    end
    self.hours[0] = {:from=>nil, :to=>nil, :open=>false} # sunday
  end

  def set_phone_number
    self.phone = [@phone_first3,@phone_second3,@phone_last4].join if @phone_first3
  end

  CAFE = 0
  RESTAURANT = 1
  BAR = 2
  SERVICE_TYPES = [CAFE, RESTAURANT, BAR]
  SERVICE_TYPE_NAMES = ['Cafe', 'Restaurant', 'Bar']



  TIME_TYPES = ['from', 'to']
  TIME_PATTERNS = ["%I", "%M", "%P"]
  SHORT_DAYNAME = ['Su', 'M', 'T', 'W', 'Th', 'F', 'S']

  Date::DAYNAMES.each_with_index do |dayname, day_index|
    hour_method = "#{dayname.downcase}_hours"

    define_method "open_#{dayname.downcase}" do
      hours[Date::DAYNAMES.index(dayname)][:open]
    end

    define_method hour_method do
      hours[Date::DAYNAMES.index(dayname)]
    end

    TIME_TYPES.each_with_index do |time_type, time_type_index|
      define_method "#{hour_method}_#{time_type}" do
        send(hour_method)[time_type.to_sym]
      end

      define_method "#{hour_method}_#{time_type}_hour" do
        send(hour_method)[time_type.to_sym].try(:strftime, "%I")
      end
      define_method "#{hour_method}_#{time_type}_min" do
        send(hour_method)[time_type.to_sym].try(:strftime, "%M")
      end
      define_method "#{hour_method}_#{time_type}_ampm" do
        send(hour_method)[time_type.to_sym].try(:strftime, "%P")
      end

      define_method "#{hour_method}_#{time_type}=" do |hash|
        hour, min, ampm = hash['hour'], hash['min'], hash['ampm']
        self.hours[day_index][time_type.to_sym] = Time.zone.parse("1970-01-01 #{hour}:#{min} #{ampm}}") rescue nil
      end
    end
  end

end