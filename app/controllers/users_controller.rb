class UsersController < ApplicationController

  def login
    @user = User.new
    render :new, :layout=> false
  end

  def new
    @user = User.new
  end
end
