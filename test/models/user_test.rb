require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'de_associate' do
    aword = Word.find_by(word: 'associate')
    assert_includes tester_amanda.words, aword
    tester_amanda.de_associate(aword)
    assert_not_includes tester_amanda.words, aword
    tester_amanda.associate(aword)
  end
end

