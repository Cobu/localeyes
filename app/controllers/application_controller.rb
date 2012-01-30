class ApplicationController < ActionController::Base
  protect_from_forgery
  #rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  before_filter :set_mobile_format

  def set_mobile_format
    request.format = :mobile if mobile_device?
  end

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

  private
  def mobile_device?
    request.user_agent =~ /Mobile|webOS|BlackBerry/ and !(request.user_agent =~ /iPad/)
  end
  helper_method :mobile_device?

  def user_from_cookie
    return if session[:user_id]
    user_id = cookies.signed[:user] rescue nil
    session[:user_id] = user_id if user_id
  end
end
