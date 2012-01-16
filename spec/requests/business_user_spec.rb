require 'spec_helper'

describe "Business User" do
  let(:user) { build(:business_user) }

  describe "creating profile" do
    before { visit businesses_path }

    it "with complete info takes you to create new business page", js: true do
      within ".register form" do
        fill_in 'business_user_email', with: user.email
        fill_in 'business_user_name', with: user.full_name
        fill_in 'business_user_password', with: "password"
        fill_in 'business_user_password_confirmation', with: "password"
        click_on "Register"
      end

      page.has_selector?('#wrapper.business_edit')
      page.current_path.should == new_business_path
    end

    it "with INCOMPLETE info keeps you on this page and shows errors", js: true do
      within ".register form" do
        fill_in 'business_user_email', with: ''
        fill_in 'business_user_name', with: user.full_name
        fill_in 'business_user_password', with: "password"
        fill_in 'business_user_password_confirmation', with: "password"
        click_on "Register"
      end

      page.has_content?("Invalid details").should == true
      page.current_path.should == businesses_path
    end
  end

  describe "logging in" do

    def sign_in( email, password )
      visit businesses_path
      within ".login form" do
        fill_in "business_user_email", with: email
        fill_in "business_user_password", with: password
        click_on "Sign in"
      end
    end

    context "when user has business" do
      it "with correct password logs in existing user", js: true do
        user.save
        b = create(:oswego_restaurant, user: user)

        sign_in user.email, user.password

        page.has_content?("Create New Business").should == true
        page.current_path.should == business_path(b)
      end

      it "with incorrect password keeps existing user on login page", js: true do
        user.save
        sign_in user.email, "wrong password"

        page.current_path.should == businesses_path
        page.has_content?("Invalid username/password").should == true
      end

      it "with email / password for non existing user keeps user on login page", js: true do
        sign_in "email@for.non.existent.user", "password"

        page.current_path.should == businesses_path
        page.has_content?("Invalid username/password").should == true
      end
    end

    context "when user has no businesses" do

      it "with correct login renders the create new business page", js: true do
        user.save
        sign_in user.email, user.password

        page.has_content?("Create New Business").should == false
        page.current_path.should == new_business_path
      end

    end

  end
end

