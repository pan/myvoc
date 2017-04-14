# frozen_string_literal: true

require 'test_helper'

class WordsControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
    assert assigns(:words)
    assert_select 'title', 'My Vocabulary'
    assert_select 'span', text: 'Logged off'
  end

  test 'should show word' do
    moon = Word.find_by word: 'moon'
    get :show, params: { id: moon.id.to_s }
    assert_template partial: '_definition'
    assert_response :success
    assert_select '.sentence', 5
  end

  test 'should create word' do
    login_tester
    drop_if_exists('factory')
    post :create, params: { term: 'factory' }
    assert_redirected_to words_path
    drop_if_exists('factory')
  end

  test 'should delete word' do
    login_tester
    post :create, params: { term: 'somewhat' }
    word = Word.find_by word: 'somewhat'
    delete :destroy, params: { id: word.id.to_s }, as: 'json'
    drop_if_exists('somewhat')
    assert_response :success
  end

  test 'should suggest word' do
    session[:user_id] = nil
    get :suggested, as: :json
    assert_response :success
  end

  private

  def drop_if_exists(word)
    w = Word.find_by word: word
    User.all.each { |u| u.de_associate(w) }
    w.destroy
  rescue Mongoid::Errors::DocumentNotFound
    false
  end
end
