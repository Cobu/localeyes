require 'spec_helper'

describe BusinessUser do

  it "can own business" do
    bu = BusinessUser.make
    b = Business.make(:nyc_restaurant, :user=>bu)
    Business.find(b.id).user.should be_instance_of BusinessUser
  end

end