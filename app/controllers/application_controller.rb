class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # check authentication status, protect from unauthorized calls to 
  # administrative methods
  def authenticate
    unless session[:user_id]
      render text: "login required." 
    end
  end

end
