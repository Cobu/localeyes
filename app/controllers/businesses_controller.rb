class BusinessesController < ApplicationController
  layout 'business_application'

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
    businesses = Business.where(:id=>params[:business_ids])
    render :json => businesses
  end

  def new
    @business = current_business_user.businesses.new
    @business.set_default_hours
  end

  def edit
    @business = current_business_user.businesses.find(params[:id])
  end

  def create
    @business = current_business_user.businesses.create(params[:business])
    # have to call 'businesses.new' first to get the hours set up
    if @business.valid?
      session[:business_id]=@business.id
      redirect_to business_path(@business), :message=>"Business created"
    else
      render :new
    end
  end

  def update
    @business = current_business_user.businesses.find(params[:id])
    if @business.update_attributes(params[:business])
      redirect_to business_path(@business), :message=>"Business updated"
    else
      render :edit
    end
  end

  def destroy
    @business = Business.find(params[:id])
  end
end