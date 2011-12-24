require Rails.root.join 'lib', 'facebook'

class UsersController < ApplicationController
  before_filter :need_business_id, :only=>[:set_favorite, :unset_favorite]
  skip_before_filter :verify_authenticity_token, :only => [:facebook_register]

  def login
    @user = User.new
    render :new, :layout=> false
  end

  def new
    @user = User.new
  end

  def unset_favorite
    current_user.remove_favorite(params[:b].to_i)
    head :ok
  end

  def set_favorite
    current_user.add_favorite(params[:b].to_i)
    head :ok
  end

  def create

  end

  def facebook_register
    user_data = Facebook.decode_user_data(params[:signed_request])
    p user_data
    head :error and return if user_data.blank? or session[:register_college].blank?
    user_data[:college_id] = session.delete(:register_college)
    user = User.find_by_email(user_data['email']) || User.create!(user_data)
    p user
    cookies.permanent.signed[:user] = user.id
    session[:user_id] = user.id
    redirect_to event_list_consumers_path
  end

  def register_college
    college = College.find_by_name( params[:college] )
    head :error and return unless college
    session[:register_college] = college.id
    head :ok
  end

  private
  def need_business_id
    head :error unless Business.find_by_id(params[:b])
  end
end
