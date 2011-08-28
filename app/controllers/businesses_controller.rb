class BusinessesController < ApplicationController
  layout 'business'

  def show
  end

  def new
    @business = current_business_user.businesses.new
  end

  def edit
    @business = Business.find(params[:id])
  end

  def create
    @business = current_business_user.businesses.new
    if  @business.update_attributes(params[:business])
      session[:business_id]=@business.id
      redirect_to business_path(@business)
    else
      render :new
    end
  end

  def update
    @business = Business.find(params[:id])
  end

  def destroy
    @business = Business.find(params[:id])
  end
end