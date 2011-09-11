class UsersController < ApplicationController

  def login
    @user = User.new
    render :new, :layout=> false
  end

  def new
    @user = User.new
  end

  def set_favorite
    head :error and return unless Business.find_by_id(params[:b]) and %(push pull).include? params[:t]
    if params[:t] == 'push'
      current_user.add_favorite(params[:b].to_i)
    else
      current_user.remove_favorite(params[:b].to_i)
    end
    head :ok
  end
end
