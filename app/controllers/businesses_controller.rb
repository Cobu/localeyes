class BusinessesController < ApplicationController
  layout 'business_application'

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