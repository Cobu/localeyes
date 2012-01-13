module LoginHelpers
  def login_user(user)
    any_instance_of(ApplicationController, current_user: user)
  end

  def login_business_user(user, business=nil)
    any_instance_of(ApplicationController, current_business_user: user)
    any_instance_of(ApplicationController, current_business: business) if business
  end
end

module TimeHelpers
  def utc_offset_hours
    Time.now.utc_offset / 3600
  end
end