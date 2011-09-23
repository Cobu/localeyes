class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
    render :template => '404', :status => 404
  end

  def current_business
    @current_business ||= current_business_user.businesses.find(session[:business_id]) if session[:business_id]
  end

  def current_business_user
    @current_business_user ||= BusinessUser.find(session[:business_user_id]) if session[:business_user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_business, :current_business_user, :current_user
end
