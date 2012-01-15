class BusinessesController < ApplicationController
  layout 'business_application'

  def geocode
    geo_lookup = params[:geo_lookup]
    Geocoder::Configuration.lookup = geo_lookup.to_sym
    coordinates = Geocoder.coordinates(params[:address])
    render :json => coordinates
  end

  def events
    start_date = Time.at(params[:start].to_i).to_date
    end_date = Time.at(params[:end].to_i).to_date
    events = current_business.events.all
    details = events.collect { |e| e.business_events(start_date, end_date) }.flatten
    render :json=> details
  end

  def show
    session[:business_id] = current_business_user.businesses.find(params[:id]).id
  end

  def index
    @new_user = BusinessUser.new
    render :home, layout: 'business_application_home'
  end

  def new
    @business = BusinessDecorator.new(current_business_user.businesses.new)
    @business.set_default_hours
  end

  def edit
    @business = current_business_user.businesses.find(params[:id])
    @business = BusinessDecorator.new @business
  end

  def create
    @business = current_business_user.businesses.create(params[:business])
    if @business.valid?
      session[:business_id] = @business.id
      redirect_to business_path(@business), :message=>"Business created"
    else
      @business = BusinessDecorator.new @business
      render :new
    end
  end

  def update
    @business = current_business_user.businesses.find(params[:id])
    if @business.update_attributes(params[:business])
      redirect_to business_path(@business), :message=>"Business updated"
    else
      @business = BusinessDecorator.new @business
      render :edit
    end
  end

  def destroy
    @business = Business.find(params[:id])
  end
end