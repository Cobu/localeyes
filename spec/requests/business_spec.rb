require 'spec_helper'

describe Business do

  describe "create" do

    before(:all) do
      @bu = BusinessUser.make
    end
    after(:all) { BusinessUser.destroy_all }

    def register_user(user)
      ApplicationController.session_data = {:business_user_id=>user.id}
    end

    it "succeeds and takes you to calendar page" do
      register_user(@bu)
      visit new_business_path
      b = Business.new Business.plan(:name=>"yo cafe",
                                     :description=>"fun cafe",
                                     :service_type=>2, # Bar
                                     :phone=>"9001112222")
      within "form" do
        fill_in 'business_name', :with => b.name
        fill_in 'business_description', :with => b.description
        select b.service_name, :from => 'business_service_type'
        fill_in 'business_address', :with => b.address
        fill_in 'business_city', :with => b.city
        select b.state, :from => 'business_state'
        fill_in 'business_zip_code', :with => b.zip_code
        fill_in 'business_phone_first3', :with => b.phone_first3
        fill_in 'business_phone_second3', :with => b.phone_second3
        fill_in 'business_phone_last4', :with => b.phone_last4
        select "5", :from => 'business_monday_hours_from_hour'
        select "15", :from => 'business_monday_hours_from_min'
        select "pm", :from => 'business_monday_hours_from_ampm'
        select "2", :from => 'business_saturday_hours_to_hour'
        select "22", :from => 'business_saturday_hours_to_min'
        select "am", :from => 'business_saturday_hours_to_ampm'
        click_on "Create Business"
      end

      bnew = Business.first

      bnew.name.should == b.name
      bnew.description.should == b.description
      bnew.service_type.should == b.service_type
      bnew.address.should == b.address
      bnew.city.should == b.city
      bnew.state.should == b.state
      bnew.zip_code.should == b.zip_code
      bnew.phone.should == b.phone
      bnew.monday_hours[:from].should == Time.utc(1970, 1, 1, 17, 15)
      bnew.saturday_hours[:to].should == Time.utc(1970, 1, 1, 2, 22)
      # the tuesday hours should have been set by default in controller new action
      bnew.tuesday_hours[:from].should == Time.utc(1970, 1, 1, 9, 0)
      bnew.tuesday_hours[:to].should == Time.utc(1970, 1, 1, 17, 0)

      page.current_path.should == business_path(bnew)
    end

    it "fails and keeps you on create page" do
      register_user(@bu)
      visit new_business_path
      b = Business.new(:name=>"yo cafe")

      within "form" do
        fill_in 'business_name', :with => b.name
        click_on "Create Business"
      end

      page.current_path.should == businesses_path
    end
  end

  describe "edit" do

    def register_user_business(user,business)
      ApplicationController.session_data = {:business_user_id=>user.id,:business_id=>business.id}
    end

    before(:all) do
      @bu = BusinessUser.make
      @b = Business.make(:nyc_cafe, :user=>@bu)
      @b.set_default_hours
      @b.save
    end
    after(:all) { BusinessUser.destroy_all }

    before(:each) do
      register_user_business(@bu,@b)
      visit edit_business_path(@b)
    end

    it "succeeds and takes you to calendar page" do
      b = Business.new Business.plan(:name=>"yo cafe",
                                      :description=>"fun cafe",
                                      :address=>"moo lane",
                                      :city=>"Westport",
                                      :state=>"CT",
                                      :zip_code=>"06880",
                                      :service_type=>2, # Bar
                                      :phone=>"9001112222")

       within "form" do
         fill_in 'business_name', :with => b.name
         fill_in 'business_description', :with => b.description
         select b.service_name, :from => 'business_service_type'
         fill_in 'business_address', :with => b.address
         fill_in 'business_city', :with => b.city
         select b.state, :from => 'business_state'
         fill_in 'business_zip_code', :with => b.zip_code
         fill_in 'business_phone_first3', :with => b.phone_first3
         fill_in 'business_phone_second3', :with => b.phone_second3
         fill_in 'business_phone_last4', :with => b.phone_last4
         select "5", :from => 'business_monday_hours_from_hour'
         select "15", :from => 'business_monday_hours_from_min'
         select "pm", :from => 'business_monday_hours_from_ampm'
         select "2", :from => 'business_saturday_hours_to_hour'
         select "22", :from => 'business_saturday_hours_to_min'
         select "am", :from => 'business_saturday_hours_to_ampm'
         uncheck "business_tuesday_hours_open" # change from open to closed
         click_on "Update Business"
       end

       bnew = Business.first

       bnew.name.should == b.name
       bnew.description.should == b.description
       bnew.service_type.should == b.service_type
       bnew.address.should == b.address
       bnew.city.should == b.city
       bnew.state.should == b.state
       bnew.zip_code.should == b.zip_code
       bnew.phone.should == b.phone
       bnew.monday_hours[:from].should == Time.utc(1970, 1, 1, 17, 15)
       bnew.saturday_hours[:to].should == Time.utc(1970, 1, 1, 2, 22)
       bnew.tuesday_hours[:open].should == false
       bnew.tuesday_hours[:from].should == nil

       page.current_path.should == business_path(bnew)
    end

    it "fails and keeps you on edit page" do
      within "form" do
        fill_in 'business_name', :with => ''
        click_on "Update Business"
      end

      page.current_path.should == business_path(@b)
    end

  end
end

