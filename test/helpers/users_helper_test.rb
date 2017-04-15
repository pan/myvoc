# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'login?' do
    user_on
    assert login?
  end
end
