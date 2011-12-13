class ConsumersController < ApplicationController
  layout  'consumer_application'
  #layout -> controller { mobile_device? ? false : 'consumer_application' }

  def register
  end

  def index
  end

  def home
  end

  def search_college
    college_results = College.search(params[:term]).all
    json = college_results.collect{|c| {label: c.name, id: c.id} }
    render json: json
  end

  def search_location
    college_results = College.search(params[:term]).all
    zip_results = ZipCode.search(params[:term]).all
    render :json => college_results + zip_results
  end

  def events
    start_date = Time.zone.parse(params[:time])
    end_date = Time.now.utc + 7.days
    center = find_center
    zip_code = ZipCode.where(zip_code: params[:zip_code]).first
    businesses = Business.near(zip_code)
    events = businesses.collect(&:events).flatten
    events = events.collect { |e| e.consumer_events(start_date, end_date) }.flatten
    favorites = current_user.try(:favorites) || []
    render :json=> { businesses: businesses, events: events, favorites: favorites, center: center }
  end

  private
  def find_center
    if params[:t] == 'c'
      College.get_center_info(params[:d])
    else
      ZipCode.get_center_info(params[:d])
    end
  end
end