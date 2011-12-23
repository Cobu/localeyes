require 'spec_helper'

describe "Business User" do
  let(:user) { BusinessUser.make }

  describe "creating profile" do
    before {  visit new_business_user_path }

    it "with complete info takes you to create new busines page" do
      within "form" do
        fill_in 'business_user_email', with: user.email
        fill_in 'business_user_first_name', with: user.first_name
        fill_in 'business_user_last_name', with: user.last_name
        fill_in 'business_user_phone', with: user.phone
        fill_in 'business_user_password', with: "password"
        fill_in 'business_user_password_confirmation', with: "password"
        click_on "Create"
      end

      page.current_path.should == new_business_path
    end

    it "with IN COMPLETE info keeps you on this page and shows errors" do
      within "form" do
        fill_in 'business_user_email', with: ''
        fill_in 'business_user_first_name', with: user.first_name
        fill_in 'business_user_last_name', with: user.last_name
        fill_in 'business_user_phone', with: user.phone
        fill_in 'business_user_password', with: "password"
        fill_in 'business_user_password_confirmation', with: "password"
        click_on "Create"
      end

      page.current_path.should == business_users_path
      page.has_content?("Email can't be blank").should == true
    end
  end

  describe "logging in" do

    it "with correct password logs in existing user" do
      user.save
      b = Business.make!(:oswego_restaurant, user: user)

      visit login_business_users_path

      within "form" do
        fill_in "business_user_email", with: user.email
        fill_in "business_user_password", with: user.password
        click_on "Sign in"
      end

      page.current_path.should == business_path(b)
    end

    it "with incorrect password keeps existing user on login page" do
      user.save
      visit login_business_users_path

      within "form" do
        fill_in "business_user_email", with: user.email
        fill_in "business_user_password", with: "wrong password"
        click_on "Sign in"
      end

      page.current_path.should == login_business_users_path
      page.has_content?("Wrong username/password").should == true
    end

    it "with email / password for non existing user keeps user on login page" do
      visit login_business_users_path

      within "form" do
        fill_in "business_user_email", with: "email@for.non.existent.user"
        fill_in "business_user_password", with: "password"
        click_on "Sign in"
      end

      page.current_path.should == login_business_users_path
      page.has_content?("Wrong username/password").should == true
    end
  end
end

