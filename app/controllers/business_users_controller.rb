class BusinessUsersController < ApplicationController

  def login
    @user = BusinessUser.new
  end

  def login_submit
    @user = BusinessUser.authenticate(params[:business_user][:email],params[:business_user][:password])

    redirect_to(login_business_users_path, :alert => 'Wrong username/password') and return unless @user

    session[:business_user_id] = @user.id
    send_to_business
  end

  def new
    @user = BusinessUser.new
  end

  def edit
    @user = BusinessUser.find(params[:id])
  end

  def create
    @user = BusinessUser.create(params[:business_user])
    render :new and return unless @user.valid?
    session[:business_user_id] = @user.id
    redirect_to new_business_path
  end

  def update
    @user = BusinessUser.find(params[:id])
  end

  private

  def send_to_business
    business = @user.businesses.first
    session[:business_id] = business.id
    redirect_to business_path(business)
  end

end