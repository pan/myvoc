class UsersController < ApplicationController

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
    render nothing: true
  end

  # when a user fails to login
  def failure
    redirect_to root_url, notice: params[:message]
  end
end
