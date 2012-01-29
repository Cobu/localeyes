require 'spec_helper'

describe "Business User" do

  before { Capybara.current_driver = :webkit }
  after { Capybara.use_default_driver }

  describe "creating profile" do
    let(:user) { build(:business_user) }
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

      page.should have_content("email can't be blank")
      page.current_path.should == businesses_path
    end
  end

  describe "logging in" do

    let(:user) { create(:business_user) }

    def sign_in( email, password )
      visit businesses_path
      within ".login form" do
        fill_in "business_user_email", with: email
        fill_in "business_user_password", with: password
        click_on "Sign in"
      end
    end

    context "when user has business" do

      it "works with correct password", js: true do
        #### big problem with factory girl on this business user assoc ####
        #### something to do with reloading classes                   #####
        user = BusinessUser.create(
          email: 'buiz_guy@isell.com',
          first_name: 'Biz',
          password: 'dudedude',
          last_name: 'Guy')
        b = create(:oswego_restaurant, user: user)

        sign_in user.email, user.password

        page.should have_content('Create New Business')
        page.current_path.should == business_path(b)
      end

      it "fails with incorrect password and keeps you on login page", js: true do
        sign_in user.email, "wrong password"

        page.current_path.should == businesses_path
        page.should have_content("Invalid username/password")
      end

      it "with email / password for non existing user keeps user on login page", js: true do
        sign_in "email@for.non.existent.user", "password"

        page.current_path.should == businesses_path
        page.should have_content("Invalid username/password")
      end
    end

    context "when user has no businesses" do

      it "with correct login renders the create new business page", js: true do
        sign_in user.email, user.password

        page.should have_content("Current connections")
        page.current_path.should == new_business_path
      end

    end

  end
end

