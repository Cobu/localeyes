require 'spec_helper'

describe BusinessDecorator do

  before(:all) { @business = build(:business, phone: '1112223333') { |b| b.set_default_hours } }
  subject { BusinessDecorator.new(@business) }

  its(:phone_first3) { should == '111' }
  its(:phone_second3) { should == '222' }
  its(:phone_last4) { should == '3333' }

  its(:sunday_hours_from_hour) { should == nil }
  its(:sunday_hours_from_min) { should == nil }
  its(:sunday_hours_from_ampm) { should == nil }
  its(:sunday_hours_to_hour) { should == nil }
  its(:sunday_hours_to_min) { should == nil }
  its(:sunday_hours_to_ampm) { should == nil }

  for day in %w[monday tuesday wednesday thursday friday saturday]
    its("#{day}_hours_from_hour") { should == '09' }
    its("#{day}_hours_from_min") { should == '00' }
    its("#{day}_hours_from_ampm") { should == 'am' }
    its("#{day}_hours_to_hour") { should == '05' }
    its("#{day}_hours_to_min") { should == '00' }
    its("#{day}_hours_to_ampm") { should == 'pm' }
  end
end