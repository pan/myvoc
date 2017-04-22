# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      current_user = User.i(cookies.signed[:user_id])
      return current_user if current_user
      reject_unauthorized_connection
    end
  end
end
