require 'spec_helper'

describe Business do

  def set_hours(hour, min)
    Time.utc(1970, 1, 1, hour, min)
  end

  let(:business) { b = Business.make(:oswego_cafe,:user=>nil) ; b.set_default_hours ; b }
  subject { business }

  it { should respond_to :sunday_hours }
  it { should respond_to :monday_hours }
  it { should respond_to :tuesday_hours }
  it { should respond_to :wednesday_hours } # etc ..

  context "has daily hours" do
    it { business.sunday_hours.should == {:from=>nil, :to=>nil, :open=>false} }
    it { business.monday_hours.should == {:from=>set_hours(9, 0), :to=>set_hours(17, 0), :open=>true} }
  end

  context "can see from hours on day" do
    it { business.monday_hours_from.should == Time.utc(1970, 1, 1, 9, 0) }
    it { business.monday_hours_from_ampm.should == "am" }
    it { business.saturday_hours_to.should == Time.utc(1970, 1, 1, 17, 0) }
    it { business.saturday_hours_to_ampm.should == "pm" }
  end

  context "can handle null hours on closed day" do
    it { business.sunday_hours_open.should == false }
    it { business.sunday_hours_to.should == nil }
  end

  context "with hours set up" do

    it "can set hours on day" do
      business.monday_hours_from={'hour'=>"05", 'min'=>'12', 'ampm'=> 'am'}
      business.monday_hours_from.should == Time.utc(1970, 1, 1, 5, 12)
    end

    it "can set closed on day" do
      business.monday_hours_open = false
      business.monday_hours_from.should == nil
    end
  end

  context "without hours set up" do
    let(:business){ Business.new }

    it "can set hours on day" do
      business.monday_hours_from={'hour'=>"05", 'min'=>'12', 'ampm'=> 'am'}
      business.monday_hours_from.should == Time.utc(1970, 1, 1, 5, 12)
    end

    it "can set closed on day" do
      business.monday_hours_open = false
      business.monday_hours_from.should == nil
    end
  end

  it "set phone number" do
    business.user_id = 1 # = BusinessUser.make
    business.phone_first3 = "510"
    business.phone_second3 = "333"
    business.phone_last4 = "1414"
    business.save
    business.reload.phone.should == "5103331414"
  end

  describe "makes valid model" do
    before do
      @attributes = {"name"=>"yo cafe", "service_type"=>"2", "description"=>"fun cafe", "address"=>"1 Dude street", "address2"=>"",
                     "city"=>"New York", "state"=>"NY", "zip_code"=>"10003",
                     "phone_first3"=>"900", "phone_second3"=>"111", "phone_last4"=>"2222",
                     "lat" => 1, "lng"=>1,
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
      b = Business.create(@attributes.merge(:user_id=>1))
      b.valid?.should == true
    end
  end

  it "sets default hours, saves and keeps the hours" do
    business = Business.make(:oswego_cafe)
    business.set_default_hours
    business.save
    business.monday_hours_open.should == true
    business.monday_hours_from.should == Time.utc(1970, 1, 1, 9, 0)
    business.sunday_hours_open.should == false
  end
end
