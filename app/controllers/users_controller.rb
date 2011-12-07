require Rails.root.join 'lib', 'facebook'

class UsersController < ApplicationController
  before_filter :need_business_id, :only=>[:set_favorite, :unset_favorite]

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

  def facebook
    data = Facebook.decode_data(params[:signed_request])
    Rails.logger.info data
    head :ok
  end

  private
  def need_business_id
    head :error unless Business.find_by_id(params[:b])
  end
end
