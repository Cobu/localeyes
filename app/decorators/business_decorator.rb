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
end