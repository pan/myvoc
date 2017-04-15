# frozen_string_literal: true

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

ENV['RAILS_ENV'] ||= 'test'
ActiveSupport::TestCase.file_fixture_path = Rails.root.join('test', 'fixtures')

puts "WARNING:Testing in #{ENV['RAILS_ENV']} mode" if ENV['RAILS_ENV'] != 'test'

module ActiveSupport
  class TestCase
    # Add more helper methods to be used by all tests here...

    # login the tester with a real db user
    def login_tester
      session[:user_id] = tester_amanda.id.to_s
    end

    # give user a id and avoid db querying
    def user_on
      session[:user_id] = '3980284084'
    end

    def tester_amanda
      User.find_by(uid: 199)
    end
  end
end
