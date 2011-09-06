class ConsumersController < ApplicationController
  layout 'consumer_application'

  def search_location
    college_results = College.search(params[:term]).all
    zip_results = ZipCode.search(params[:term]).all
    render :json => college_results + zip_results
  end

  def events
    start_date = Time.now.utc.to_date
    end_date = Time.now.utc.to_date + 7.days
    businesses = Business.where(:zip_code=>params[:zip_code])
    events = businesses.collect(&:events).flatten
    events = events.collect { |e| e.consumer_events(start_date, end_date) }.flatten
    render :json=> {businesses: businesses, events: events}
  end
end