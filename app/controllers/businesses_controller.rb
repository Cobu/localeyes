class BusinessesController < ApplicationController
  layout 'business'

  def show
  end

  def new
    @business = Business.new
  end

  def edit
    @business = Business.find(params[:id])
  end

  def create
    @business = Business.new(params[:businesses])
    @business.save
    render :edit
  end

  def update
    @business = Business.find(params[:id])
  end

  def destroy
    @business = Business.find(params[:id])
  end
end