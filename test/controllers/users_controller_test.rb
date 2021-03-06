require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "can login" do
    session[:user_id] = nil
    authenv = { provider: 'github', uid: 188, info: {name: "Tester Lam"} }
    @request.headers["omniauth.auth"] = authenv
    assert_routing '/auth/github/callback', 
      { controller: 'users', action: 'create', provider: 'github' }
    get :create, params: { provider: 'github' }
    assert_not_nil session[:user_id]
    assert_redirected_to root_path
  end

  test "can logout" do
    user_on
    get :logout
    assert_nil session[:user_id]
    assert_not session[:admin]
    assert_response :success
  end

  test "login failure" do
    get :failure 
    assert_routing '/auth/failure', { controller: 'users', action: 'failure' }
    assert_redirected_to root_path
  end

  test "can turn on/off admin" do
    user_on
    get :admin, params: { req: 'on', format: 'json' }
    assert session[:admin]
    assert_response :success
    get :admin, params: { req: 'off', format: 'json' }
    assert_not session[:admin]
    assert_response :success
  end
end
