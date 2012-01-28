class BusinessUsersController < ApplicationController
  layout 'business_application'

  def login
    @user = BusinessUser.new
  end

  def login_submit
    @user = BusinessUser.authenticate(params[:business_user][:email],params[:business_user][:password])
    render(text: 'Invalid username/password', status: 404) and return unless @user

    reset_session
    session[:business_user_id] = @user.id
    business = @user.businesses.first

    render json: {} and return unless business

    session[:business_id] = business.id
    render json: {business: business.id}
  end

  def new
    @user = BusinessUser.new
  end

  def edit
    @user = BusinessUser.find(params[:id])
  end

  def create
    reset_session
    @user = BusinessUser.create(params[:business_user])
    render(text: 'Invalid details', status: 400) and return unless @user.valid?

    session[:business_user_id] = @user.id
    head :ok
  end

  def update
    @user = BusinessUser.find(params[:id])
  end

end