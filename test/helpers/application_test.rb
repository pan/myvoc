require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup 
    session[:admin] = false
  end

  test "admin?" do
    refute admin?
    session[:admin] = true
    assert admin?
  end

  test "admin_stat" do
    assert_equal "off", admin_stat
  end

  test "hide_admin" do
    assert_equal "hide", hide_admin
  end

  test "powered_by" do
    assert_match Regexp.new("<a.+</a>"), powered_by
  end
end
