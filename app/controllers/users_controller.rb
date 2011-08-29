class UsersController < ApplicationController
  layout 'consumer_application'

  def login
    @user = User.new
  end

  def new
    @user = User.new
  end
end
