# frozen_string_literal: true

require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
  test 'upload nothing' do
    user_on
    post :upload, xhr: true
    refute_empty @response.body
  end

  test 'file type' do
    user_on
    post :upload, params: { list: up_file('application/word') }, xhr: true
    assert_match /Only plain text file can be uploaded./, @response.body
  end

  test 'file size' do
    user_on
    uploadfile = empty_file
    post :upload, params: { list: uploadfile }, xhr: true
    message = "File size: #{uploadfile.size} is not in the allowed " \
         'range \[1,10M\]'
    assert_match Regexp.new(message), @response.body
  end

  test 'upload file' do
    login_tester
    post :upload, params: { list: up_file }, xhr: true
    assert_match /uploaded/, @response.body
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
