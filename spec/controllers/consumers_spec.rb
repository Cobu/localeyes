require 'spec_helper'

describe ConsumersController do

  context '#home' do

    let(:user_id) { 1 }

    it "user with session goes to event page" do
      session[:user_id] = user_id
      mock(User).find(user_id) { build(:user) }
      get :home
      should redirect_to event_list_consumers_path
    end

    it "user with cookie goes to events page" do
      jar = ActionDispatch::Cookies::CookieJar.build(request)
      jar.signed[:user] = 1
      request.cookies[:user] = jar[:user]
      mock(User).find(user_id) { build(:user) }
      get :home
      should redirect_to event_list_consumers_path
    end

    it "user without session or cookie goes to home page" do
      get :home
      should render_template 'home'
    end

  end

  context '#event_list' do
    let(:user) { create(:user) }
    let(:cafe) { create(:oswego_cafe) }
    let(:now) { Time.now.utc }
    render_views

    it "generates fixture" do
      college = create(:suny_oswego)
      create(:once_event,
             :business=>cafe,
             :start_time => now.change(:min => 0, :sec => 0).advance(:hours => utc_offset_hours + 1),
             :end_time => now.change(:min => 0, :sec => 0).advance(:hours => utc_offset_hours + 2),
             :title=>"one times")

      get :event_list, college: college.id
      response.should be_success
      save_fixture(response.body, 'event_list_page')
    end
  end
end
