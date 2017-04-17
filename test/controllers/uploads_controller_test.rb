# frozen_string_literal: true

require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
  test 'upload nothing' do
    user_on
    post :upload
    assert_redirected_to root_path
    refute_empty flash[:notice]
  end

  test 'file type' do
    user_on
    post :upload, params: { list: up_file('application/word') }
    assert_redirected_to root_path
    assert_equal 'Only plain text file can be uploaded.', flash[:notice]
  end

  test 'file size' do
    user_on
    uploadfile = empty_file
    post :upload, params: { list: uploadfile }
    assert_redirected_to root_path
    message = "File size: #{uploadfile.size} is not in the allowed " \
         'range [1,10M].'
    assert_equal message, flash[:notice]
  end

  test 'upload file' do
    login_tester
    post :upload, params: { list: up_file }
    assert_redirected_to root_path
    assert flash[:notice].include? 'uploaded'
  end

  test 'filetext clean' do
    @controller.params[:list] = up_file
    text = @controller.send(:filetext)
    assert_equal %w[visual zoom], @controller.send(:clean, text)
  end

  private

  def up_file(type = 'text/plain')
    Rack::Test::UploadedFile.new(file_fixture('upload.txt'), type)
  end

  def empty_file
    Rack::Test::UploadedFile.new(file_fixture('empty'))
  end
end
