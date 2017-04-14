# frozen_string_literal: true

# application controller is the base for other controllers
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  delegate :login?, to: :helpers

  # check authentication status, protect from unauthorized calls to
  # administrative methods
  def authenticate
    render text: 'login required.' unless login?
  end

  def uid
    session[:user_id]
  end

  def current_user
    User.i(uid)
  end
end
