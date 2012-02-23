class ConsumersController < ApplicationController
  layout 'consumer_application'
  #layout -> controller { mobile_device? ? false : 'consumer_application' }
  before_filter :user_from_cookie, only: [:home, :events]

  def register
  end

  def event_list
    if college = College.find_by_id(params[:college]) || current_user.try(:college)
      setup_consumer_events(CollegeDecorator.decorate(college))
    end
  end

  def home
    redirect_to event_list_consumers_path if current_user
  end

  def search_college
    @colleges = College.search(params[:term]).all
  end

  def location_search
    colleges = CollegeDecorator.decorate(College.search(params[:term])).to_ary
    zips = ZipCodeDecorator.decorate(ZipCode.search(params[:term])).to_ary
    @locations = (colleges + zips)
  end

  def events
    center = (params[:t] == 'z') ? ZipCodeDecorator.find(params[:d]) : CollegeDecorator.find(params[:d]) rescue nil
    head :ok and return unless center
    setup_consumer_events(center)
  end

  def notify
    if params[:college].present? and params[:email].present?
      Notification.find_or_create_by_email_and_college(params[:email], params[:college])
    end
    head :ok
  end

  private

  def setup_consumer_events(center)
    @center = center
    # NOTE: very important, the way start_date is set to now time wih => [Time.zone.at(Time.now.to_i)]
    @start_date = Time.zone.parse(params[:time]) rescue Time.zone.at(Time.now.to_i)
    @end_date = @start_date + 7.days
    @businesses = Business.near(@center)
    @events = @businesses.collect { |b| b.events.occurring_between?(@start_date, @end_date) }.flatten
  end
end