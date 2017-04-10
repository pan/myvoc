require 'test_helper'
require 'stringio'

class UploadsControllerTest < ActionController::TestCase
  def setup
    @uploadfile = ActionDispatch::Http::UploadedFile.new \
      tempfile: StringIO.new("visual\nzoom","r"), type: 'text/plain'
  end

  test "upload nothing" do
    user_on
    post :upload
    assert_redirected_to root_path
    refute_empty flash[:notice]
  end

  test "file type" do
    user_on
    @uploadfile.content_type = 'application/word'
    post :upload, params: { list: @uploadfile }
    assert_redirected_to root_path
    assert_equal "Only plain text file can be uploaded.", flash[:notice]
  end

  test "file size" do
    user_on
    @uploadfile = ActionDispatch::Http::UploadedFile.new \
      tempfile: StringIO.new('',"r"), type: 'text/plain'
    post :upload, params: { list: @uploadfile }
    assert_redirected_to root_path
    message = "Your file size: #{@uploadfile.size} is not in the allowed" +
         "range [1,10M]."
    assert_equal message, flash[:notice]
  end

  test "upload file" do
    login_tester
    post :upload, params: { list: @uploadfile }
    assert_redirected_to root_path
    assert flash[:notice].include? "uploaded"
  end
end
