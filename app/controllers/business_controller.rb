class BusinessController < ApplicationController

  def index
    start_date = Time.at(params[:start].to_i).to_date
    end_date = Time.at(params[:end].to_i).to_date
    events = current_business.events.all
    details = events.collect { |e| e.occurrences_between(start_date, end_date) }.flatten
    render :json=> details
  end

  def show
  end

  def new
    @event = Event.new(:start_time=>params[:start_time],:end_time=>params[:end_time])
    render :edit, :layout => "events"
  end

  def edit
    @b = Business.find(params[:id])
    render :layout=> 'events'
  end

  def create
    e = Event.new(params[:event])
    e.business = current_business
    e.save
    head :ok
  end

  def update
    @event = Event.find(params[:id])
    head :ok
  end

  def destroy
    @event = Event.find(params[:id])
    head :ok
  end

end