module UsersHelper
  # return true if a user has logged in
  def login?
    session[:user_id] ? true : false
  end
end
