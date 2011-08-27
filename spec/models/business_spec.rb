require 'spec_helper'

describe Business do

  def set_hours(hour, min)
    Time.utc(1970, 1, 1, hour, min)
  end

  before(:all) { @b = Business.make(:nyc_cafe) }
  after(:all) { BusinessUser.destroy_all }

  subject { @b }
  it { should respond_to :sunday_hours }
  it { should respond_to :monday_hours }
  it { should respond_to :tuesday_hours }
  it { should respond_to :wednesday_hours } # etc ..

  context "has daily hours" do
    it { @b.sunday_hours.should == {:from=>nil, :to=>nil, :open=>false} }
    it { @b.monday_hours.should == {:from=>set_hours(9, 0), :to=>set_hours(17, 0), :open=>true} }
  end

  context "can see from hours on day" do
    it { @b.monday_hours_from.should == Time.utc(1970, 1, 1, 9, 0) }
    it { @b.monday_hours_from_ampm.should == "am" }
    it { @b.saturday_hours_to.should == Time.utc(1970, 1, 1, 17, 0) }
    it { @b.saturday_hours_to_ampm.should == "pm" }
  end

  context "can handle null hours on closed day" do
    it { @b.open_sunday.should == false }
    it { @b.sunday_hours_to.should == nil }
  end

  it "can set hours on day" do
    b = Business.new
    b.monday_hours_from={'hour'=>"05", 'min'=>'12', 'ampm'=> 'am'}
    b.monday_hours_from.should == Time.utc(1970, 1, 1, 5, 12)
  end

  it "set phone number" do
    @b.phone_first3 = "510"
    @b.phone_second3 = "333"
    @b.phone_last4 = "1414"
    @b.save
    @b.reload.phone.should == "5103331414"
  end
end
