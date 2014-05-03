require 'test_helper'

class WordsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show word" do
    moon = Word.find_by word: 'moon'
    get :show, id: moon.id.to_s
    assert_template partial: '_definition'
    assert_response :success
  end

  test "should create word" do
    login_tester
    post :create, {term: 'automation'}, session
    assert_redirected_to words_path
  end

  test "should delete word" do
    login_tester
    word = Word.find_by word: 'automation'
    delete :destroy, id: word.id.to_s, format: 'json'
    assert_response :success
  end

  test "should suggest word" do
    session[:user_id] = nil
    get :suggested, format: :json
    assert_response :success
  end
end
