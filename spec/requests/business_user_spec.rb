require 'spec_helper'

describe "Business User" do

  before(:each) do
  end

  describe "creating profile" do
    it "with complete info takes you to create new busines page" do
      visit new_business_user_path

      bu = BusinessUser.make
      within "form" do
        fill_in 'business_user_email', :with => bu.email
        fill_in 'business_user_first_name', :with => bu.first_name
        fill_in 'business_user_last_name', :with => bu.last_name
        fill_in 'business_user_phone', :with => bu.phone
        fill_in 'business_user_password', :with => "password"
        fill_in 'business_user_password_confirmation', :with => "password"
        click_on "Create"
      end

      page.current_path.should == new_business_path
    end

    it "with IN COMPLETE info keeps you on this page and shows errors" do
      visit new_business_user_path

      bu = BusinessUser.make
      within "form" do
        fill_in 'business_user_email', :with => ''
        fill_in 'business_user_first_name', :with => bu.first_name
        fill_in 'business_user_last_name', :with => bu.last_name
        fill_in 'business_user_phone', :with => bu.phone
        fill_in 'business_user_password', :with => "password"
        fill_in 'business_user_password_confirmation', :with => "password"
        click_on "Create"
      end

      page.current_path.should == business_users_path
      page.has_content?("Email can't be blank").should == true
    end
  end

  describe "logging in" do
    it "with correct password logs in existing user" do
      password = "dudeman"
      bu = BusinessUser.make!(:password=>password)
      b = Business.make!(:oswego_restaurant, :user=>bu)

      visit login_business_users_path

      within "form" do
        fill_in "business_user_email", :with=> bu.email
        fill_in "business_user_password", :with=> password
        click_on "Sign in"
      end

      page.current_path.should == business_path(b)
    end

    it "with incorrect password keeps existing user on login page" do
      bu = BusinessUser.make!

      visit login_business_users_path

      within "form" do
        fill_in "business_user_email", :with=> bu.email
        fill_in "business_user_password", :with=> "wrong password"
        click_on "Sign in"
      end

      page.current_path.should == login_business_users_path
      page.has_content?("Wrong username/password").should == true
    end

    it "with email / password for non existing user keeps user on login page" do
      visit login_business_users_path

      within "form" do
        fill_in "business_user_email", :with=> "email@for.non.existent.user"
        fill_in "business_user_password", :with=> "password"
        click_on "Sign in"
      end

      page.current_path.should == login_business_users_path
      page.has_content?("Wrong username/password").should == true
    end
  end
end

