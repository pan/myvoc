require 'test_helper'

class LoginSearchTest < ActionDispatch::IntegrationTest
  test "login and search" do
    get "/auth/github"
    redirect?

    login_tester
    get "/words/suggested.json/", term: 'cook'
    assert_response :success
    css_select ".example", ".sentence"
  end
end
