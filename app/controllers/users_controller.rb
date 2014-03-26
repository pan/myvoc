class UsersController < ApplicationController
  before_action :authenticate, only: [:logout, :admin]

  # login a user
  def create
    auth = request.env["omniauth.auth"]
    @user = User.find_init_update auth
    session[:user_id] = @user.id
    redirect_to root_path
  end

  # logout a user by deleting its session user id
  def logout
    session[:user_id] = nil
    session[:admin] = false
    render nothing: true
  end

  # when a user fails to login
  def failure
    redirect_to root_url, notice: params[:message]
  end

  # turn admin on/off
  def admin
    if params[:req] == "on"
       session[:admin] = true
    else
      session[:admin] = false
    end
    render nothing: true
  end
end
