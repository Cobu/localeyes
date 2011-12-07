def login_user(user)
  any_instance_of(ApplicationController, current_user: user)
end

def login_business_user(user)
  any_instance_of( ApplicationController, current_business_user: user )
end
