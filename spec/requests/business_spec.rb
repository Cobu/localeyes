require 'spec_helper'

describe Business do

  let(:user) { create(:business_user) }

  describe "create" do

    before do
      login_business_user user
      visit new_business_path
    end

    it "succeeds and takes you to calendar page" do

      b = build(:oswego_cafe)

      within "form" do
        fill_in 'business_name', with: b.name
        fill_in 'business_description', with: b.description
        select b.service_name, from: 'business_service_type'
        fill_in 'business_address', with: b.address
        fill_in 'business_city', with: b.city
        select b.state, from: 'business_state'
        fill_in 'business_zip_code', with: b.zip_code
        fill_in 'business_phone_first3', with: b.phone_first3
        fill_in 'business_phone_second3', with: b.phone_second3
        fill_in 'business_phone_last4', with: b.phone_last4
        select "5", from: 'business_monday_hours_from_hour'
        select "15", from: 'business_monday_hours_from_min'
        select "pm", from: 'business_monday_hours_from_ampm'
        select "2", from: 'business_saturday_hours_to_hour'
        select "30", from: 'business_saturday_hours_to_min'
        select "am", from: 'business_saturday_hours_to_ampm'
        click_on "Save"
      end

      bnew = Business.first

      bnew.name.should == b.name
      bnew.description.should == b.description
      bnew.service_name.should == b.service_name
      bnew.address.should == b.address
      bnew.city.should == b.city
      bnew.state.should == b.state
      bnew.zip_code.should == b.zip_code
      bnew.phone.should == b.phone
      bnew.monday_hours[:from].should == Time.utc(1970, 1, 1, 17, 15)
      bnew.saturday_hours[:to].should == Time.utc(1970, 1, 1, 2, 30)
      # the tuesday hours should have been set by default in controller new action
      bnew.tuesday_hours[:from].should == Time.utc(1970, 1, 1, 9, 0)
      bnew.tuesday_hours[:to].should == Time.utc(1970, 1, 1, 17, 0)

      page.current_path.should == business_path(bnew)
    end

    it "fails and keeps you on create page" do

      b = Business.new(:name=>"yo cafe")

      within "form" do
        fill_in 'business_name', with: b.name
        click_on "Save"
      end

      page.current_path.should == businesses_path
    end
  end

  describe "edit" do

    let(:business) { create(:oswego_cafe) }

    before(:each) do
      login_business_user business.user
      visit edit_business_path business
    end

    it "succeeds and takes you to calendar page" do

      within "form.edit_business" do
        fill_in 'business_name', with: business.name
        fill_in 'business_description', with: business.description
        select business.service_name, from: 'business_service_type'
        fill_in 'business_address', with: business.address
        fill_in 'business_city', with: business.city
        select business.state, from: 'business_state'
        fill_in 'business_zip_code', with: business.zip_code
        fill_in 'business_phone_first3', with: business.phone_first3
        fill_in 'business_phone_second3', with: business.phone_second3
        fill_in 'business_phone_last4', with: business.phone_last4
        select "5", from: 'business_monday_hours_from_hour'
        select "15", from: 'business_monday_hours_from_min'
        select "pm", from: 'business_monday_hours_from_ampm'
        select "2", from: 'business_saturday_hours_to_hour'
        select "45", from: 'business_saturday_hours_to_min'
        select "am", from: 'business_saturday_hours_to_ampm'
        uncheck "business_tuesday_hours_open" # change from open to closed
        click_on "Save"
      end

      bnew = Business.first

      bnew.name.should == business.name
      bnew.description.should == business.description
      bnew.service_type.should == business.service_type
      bnew.address.should == business.address
      bnew.city.should == business.city
      bnew.state.should == business.state
      bnew.zip_code.should == business.zip_code
      bnew.phone.should == business.phone
      bnew.monday_hours[:from].should == Time.utc(1970, 1, 1, 17, 15)
      bnew.saturday_hours[:to].should == Time.utc(1970, 1, 1, 2, 45)
      bnew.tuesday_hours[:open].should == false
      bnew.tuesday_hours[:from].should == nil

      page.current_path.should == business_path(bnew)
    end

    it "fails and keeps you on edit page" do

      within "form.edit_business" do
        fill_in 'business_name', with: ''
        click_on "Save"
      end

      page.current_path.should == business_path(business)
    end

  end
end

