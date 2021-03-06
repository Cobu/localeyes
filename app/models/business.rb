class Business < ActiveRecord::Base
  belongs_to :user, :class_name => 'BusinessUser'
  has_many :events, :dependent => :destroy do
    def occurring_between?(start_time, end_time)
      proxy_association.proxy.select { |event| event.occurs_between?(start_time, end_time) }
    end
  end
  has_one :zip_location, :class_name => 'ZipCode', :foreign_key => :zip_code, :primary_key => :zip_code

  validates :name, :phone, :city, :state, :zip_code, :presence => true

  geocoded_by :full_address, latitude: :lat, longitude: :lng

  before_validation :set_phone_number
  before_create :geocode, :unless => -> { lat.present? and lng.present? }
  before_create :set_default_hours

  # day order is  [sun, mon, tues, wed , thu, fri, sat]
  # hours = [ [ from: time, to: time, closed: true], etc.. for each day starting with sunday ]
  # each time uses date 1970-01-01.
  serialize :hours, Array

  HOURS_CLOSED = {:from => nil, :to => nil, :open => false}

  def full_address
    [address, address2, city, state, zip_code].compact.join(' ')
  end

  def set_default_hours
    return unless hours.blank?

    nine_am = Time.utc(1970, 1, 1, 9, 00)
    five_pm = Time.utc(1970, 1, 1, 17, 00)
    (1..6).each do |num|
      self.hours[num] = {:from => nine_am, :to => five_pm, :open => true} # monday to saturday
    end
    self.hours[0] = HOURS_CLOSED.dup  # sunday
  end

  attr_writer :phone_first3, :phone_second3, :phone_last4

  def phone_first3=(num)
    @phone_first3 = num
  end

  def set_phone_number
    self.phone = [@phone_first3, @phone_second3, @phone_last4].join if @phone_first3
  end

  unless defined? CAFE
    CAFE = 0
    RESTAURANT = 1
    BAR = 2
    RETAIL = 3
    SERVICE_TYPES = [CAFE, RESTAURANT, BAR, RETAIL]
    SERVICE_TYPE_NAMES = %w[Cafe Restaurant Bar Retail]

    TIME_TYPES = %w[from to]
    SHORT_DAYNAME = %w[Su M T W Th F Sa]
  end

  def service_name
    SERVICE_TYPE_NAMES[service_type]
  end

  Date::DAYNAMES.each_with_index do |dayname, day_index|
    hour_method = "#{dayname.downcase}_hours"

    # handle open or closed
    define_method("#{hour_method}_open") { hours[day_index][:open] }

    define_method "#{hour_method}_open=" do |val|
      open = val.to_s.match(/(true|1)/) != nil
      set_blank_hours(day_index) unless days_hours_set?(day_index)
      self.hours[day_index][:open] = open
      set_blank_hours(day_index) unless open
    end

    define_method(hour_method) { hours[day_index] }

    TIME_TYPES.each do |time_type|
      define_method "#{hour_method}_#{time_type}" do
        send(hour_method)[time_type.to_sym]
      end

      define_method "#{hour_method}_#{time_type}=" do |hash|
        set_blank_hours(day_index) unless days_hours_set?(day_index)
        hour, min, ampm = hash['hour'], hash['min'], hash['ampm']
        if hours[day_index][:open]
          self.hours[day_index][time_type.to_sym] = Time.zone.parse("1970-01-01 #{hour}:#{min} #{ampm}}")
        end
      end
    end
  end

  def set_blank_hours(day_index)
    self.hours[day_index] = HOURS_CLOSED.dup
  end

  def days_hours_set?(day_index)
    !!self.hours[day_index]
  end
end

