require 'spec_helper'

describe ConsumersController do

  context "#home" do

    let(:user_id) { 1 }

    it "user with session goes to event page" do
      session[:user_id] = user_id
      mock(User).find(user_id) { User.make(:dude) }
      get :home
      should redirect_to event_list_consumers_path
    end

    it "user with cookie goes to events page" do
      request.cookies[:user] = user_id
      mock(User).find(user_id) { User.make(:dude) }
      get :home
      should redirect_to event_list_consumers_path
    end

    it "user without session or cookie goes to home page" do
      get :home
      should render_template 'home'
    end

  end
end
