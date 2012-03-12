class BusinessDecorator < ApplicationDecorator
  decorates :business

  def phone_first3
    model.phone[0..2] if model.phone
  end

  def phone_second3
    model.phone[3..5] if model.phone
  end

  def phone_last4
    model.phone[6..9] if model.phone
  end

  Date::DAYNAMES.each do |dayname|
    hour_method = "#{dayname.downcase}_hours"

    Business::TIME_TYPES.each do |time_type|
      define_method "#{hour_method}_#{time_type}_hour" do
        send(hour_method)[time_type.to_sym].try(:strftime, "%I")
      end
      define_method "#{hour_method}_#{time_type}_min" do
        send(hour_method)[time_type.to_sym].try(:strftime, "%M")
      end
      define_method "#{hour_method}_#{time_type}_ampm" do
        send(hour_method)[time_type.to_sym].try(:strftime, "%P")
      end
    end
  end
end