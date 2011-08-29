require 'spec_helper'

describe Business do

  def set_hours(hour, min)
    Time.utc(1970, 1, 1, hour, min)
  end

  before(:all) { @b = Business.make(:nyc_cafe) }
  before(:each) { @b.set_default_hours }


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
    it { @b.sunday_hours_open.should == false }
    it { @b.sunday_hours_to.should == nil }
  end

  context "with hours set up" do
    before do
      @b1 = Business.new
      @b1.set_default_hours
    end

    it "can set hours on day" do
      @b1.monday_hours_from={'hour'=>"05", 'min'=>'12', 'ampm'=> 'am'}
      @b1.monday_hours_from.should == Time.utc(1970, 1, 1, 5, 12)
    end

    it "can set closed on day" do
      @b1.monday_hours_open = false
      @b1.monday_hours_from.should == nil
    end
  end

  context "without hours set up" do
    before do
      @b1 = Business.new
    end

    it "can set hours on day" do
      @b1.monday_hours_from={'hour'=>"05", 'min'=>'12', 'ampm'=> 'am'}
      @b1.monday_hours_from.should == Time.utc(1970, 1, 1, 5, 12)
    end

    it "can set closed on day" do
      @b1.monday_hours_open = false
      @b1.monday_hours_from.should == nil
    end
  end

  it "set phone number" do
    @b.phone_first3 = "510"
    @b.phone_second3 = "333"
    @b.phone_last4 = "1414"
    @b.save
    @b.reload.phone.should == "5103331414"
  end

  describe "makes valid model" do
    before do
      @attributes = {"name"=>"yo cafe", "service_type"=>"2", "description"=>"fun cafe", "address"=>"1 Dude street", "address2"=>"",
                     "city"=>"New York", "state"=>"NY", "zip_code"=>"10003",
                     "phone_first3"=>"900", "phone_second3"=>"111", "phone_last4"=>"2222",
                     "sunday_hours_from"=>{"hour"=>"00", "min"=>"00", "ampm"=>"am"}, "sunday_hours_to"=>{"hour"=>"00", "min"=>"00", "ampm"=>"am"}, "sunday_hours_open"=>"0",
                     "monday_hours_from"=>{"hour"=>"05", "min"=>"15", "ampm"=>"pm"}, "monday_hours_to"=>{"hour"=>"05", "min"=>"00", "ampm"=>"pm"}, "monday_hours_open"=>"1",
                     "tuesday_hours_from"=>{"hour"=>"09", "min"=>"00", "ampm"=>"am"}, "tuesday_hours_to"=>{"hour"=>"05", "min"=>"00", "ampm"=>"pm"}, "tuesday_hours_open"=>"1",
                     "wednesday_hours_from"=>{"hour"=>"09", "min"=>"00", "ampm"=>"am"}, "wednesday_hours_to"=>{"hour"=>"05", "min"=>"00", "ampm"=>"pm"}, "wednesday_hours_open"=>"1",
                     "thursday_hours_from"=>{"hour"=>"09", "min"=>"00", "ampm"=>"am"}, "thursday_hours_to"=>{"hour"=>"05", "min"=>"00", "ampm"=>"pm"}, "thursday_hours_open"=>"1",
                     "friday_hours_from"=>{"hour"=>"09", "min"=>"00", "ampm"=>"am"}, "friday_hours_to"=>{"hour"=>"05", "min"=>"00", "ampm"=>"pm"}, "friday_hours_open"=>"1",
                     "saturday_hours_from"=>{"hour"=>"09", "min"=>"00", "ampm"=>"am"}, "saturday_hours_to"=>{"hour"=>"02", "min"=>"22", "ampm"=>"am"}, "saturday_hours_open"=>"1"
      }
    end

    it "from new" do
      b = Business.new(@attributes)
      b.valid?.should == true
    end

    it "from create" do
      b = Business.create(@attributes)
      b.valid?.should == true
    end
  end

  it "sets default hours, saves and keeps the hours" do
    @b1 = Business.make(:nyc_cafe, :user=>@bu)
    @b1.set_default_hours
    @b1.save
    @b1.monday_hours_open.should == true
    @b1.monday_hours_from.should == Time.utc(1970, 1, 1, 9, 0)
    @b1.sunday_hours_open.should == false
  end
end
