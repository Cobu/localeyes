require 'spec_helper'

describe BusinessUser do
  it "can own business" do
    bu = build(:business_user)
    b = create(:oswego_restaurant, :user=>bu)
    Business.find(b.id).user.should be_instance_of BusinessUser
  end
end

describe User do
  it "sets birthday with m/d/y date" do
    birthday = "12/29/1945"
    user = build(:user, birthday: birthday)
    user.birthday.should == Date.strptime(birthday, '%m/%d/%Y')
  end
end