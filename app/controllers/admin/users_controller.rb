class Admin::UsersController < ApplicationController
  layout 'admin'
  respond_to :html
  before_filter :authenticate_user!, :require_admin!

  def index
    @users = User.page(params[:page]).per_page(20)
    respond_with @users
  end

  def edit
    @user = User.find(params[:id])
    respond_with @user
  end

  def update
    @user = User.find(params[:id])
    flash[:notice] = 'User updated' if @user.update_attributes(user_params)
    respond_with @user, location: admin_users_path
  end

  def delete
    @user = User.find(params[:id])
    @user.update_attribute(:deleted_at, Time.now)
    respond_with @user, location: admin_users_path
  end

  protected
    def user_params
      params.require(:user).permit(:email, :admin, :name, tribunal_ids: [])
    end
end