# frozen_string_literal: true

# users helper module
module UsersHelper
  # return true if a user has logged in
  def login?
    !session[:user_id].nil?
  end
end
