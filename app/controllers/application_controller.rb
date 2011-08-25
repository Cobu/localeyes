class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_business
    @current_business ||= Business.first
  end
  helper_method :current_business
end
