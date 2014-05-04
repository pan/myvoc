require 'test_helper'

class WordsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert assigns(:words)
    assert_select "title", "My Vocabulary"
    assert_select "span", {text: "Logged off"}
  end

  test "should show word" do
    moon = Word.find_by word: 'moon'
    get :show, id: moon.id.to_s
    assert_template partial: '_definition'
    assert_response :success
    assert_select ".sentence", 5
  end

  test "should create word" do
    login_tester
    post :create, {term: 'automation'}
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
