ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...

  # login the tester with a real db user
  def login_tester
    session[:user_id] = User.find_by(uid: 199).id.to_s
  end

  # give user a id and avoid db querying
  def user_on
    session[:user_id] = "3980284084"
  end
end
