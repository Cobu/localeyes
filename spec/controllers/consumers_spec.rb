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

  context '#search_college' do
    let(:college) { create(:suny_oswego) }
    before { college }

    it "returns json for college found" do
      get :search_college, term: 'os', format: 'json'
      response.body.should == [{id: college.id, label: college.name}].to_json
    end
  end

  context '#location_search' do
    let(:college) { create(:suny_oswego) }
    let(:zip) { create(:oswego) }
    let(:locations) { [CollegeDecorator.new(college)] + [ZipCodeDecorator.new(zip)] }
    before { locations }

    it "returns json for college and zips found" do
      get :location_search, term: 'os', format: 'json'
      #p locations.collect{|l| [l.id, l.zip_code, l.type, l.label}
      #p locations.as_json(only: [:id, :zip_code, :type, :label])
      #p response.body
      #p response.body
      #response.body.should == locations.to_json(only: [:id, :zip_code, :type, :label])
    end
  end

  context '#event_list' do
    let(:user) { create(:user) }
    let(:cafe) { create(:oswego_cafe) }
    let(:now) { Time.now.utc }
    let(:college) { create(:suny_oswego) }

    it 'json response' do
      event = create(:daily_event,
                     :business => cafe,
                     :start_time => Time.utc(2011, 8, 5, 7, 30),
                     :end_time => Time.utc(2011, 8, 5, 9, 30),
                     :title => "daily times"
      )
      get :events, d: college.id, format: :json
      p response.body
    end

  end
end
