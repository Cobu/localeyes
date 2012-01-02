class ConsumersController < ApplicationController
  layout  'consumer_application'
  #layout -> controller { mobile_device? ? false : 'consumer_application' }
  before_filter :user_from_cookie, only: [:home, :events]

  def register
  end

  def event_list
    if college = College.find_by_id(params[:college]) || current_user.try(:college)
      @data = consumer_events(college)
    end
  end

  def home
  end

  def search_college
    colleges = College.search(params[:term]).all
    render json: colleges.collect{|c| {label: c.name, id: c.id} }
  end

  def search_location
    colleges = College.search(params[:term]).all
    zips = ZipCode.search(params[:term]).all
    render json: colleges + zips
  end

  def events
    center = (params[:t] == 'z') ? ZipCode.find_by_id(params[:d]) : College.find_by_id(params[:d])
    render :json=> consumer_events(center)
  end

  def notify
    if params[:college].present? and params[:email].present?
      Notification.find_or_create_by_email_and_college(params[:email], params[:college])
    end
    head :ok
  end

  private

  def consumer_events(center)
    start_date = Time.zone.parse(params[:time]) rescue Time.now.utc
    end_date = Time.now.utc + 7.days
    businesses = Business.near(center)
    events = businesses.collect(&:events).flatten
    events = events.collect { |e| e.consumer_events(start_date, end_date) }.flatten
    favorites = current_user.try(:favorites) || []
    {
      businesses: businesses,
      events: events,
      favorites: favorites,
      center: center.center_json,
      votes: EventVote.votes_for_events(events.collect{ |h| h[:id].to_i }.uniq)
    }
  end
end