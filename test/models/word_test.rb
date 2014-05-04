require 'test_helper'

class WordTest < ActiveSupport::TestCase
  test "search should get all words" do
    all_words = Word.search
    assert_equal Word.count, all_words.size, "Not all words are got"
  end

  test "search should support regex"  do
    words_begin_with_m = Word.search("^m")
    assert_equal 2, words_begin_with_m.size, 
      "We have populated two words beginning with letter m, haven't we?"
  end

  test "should get definition"  do
    definitions = Word.get_defs("moon")
    refute_nil definitions
  end

  test "should init definition"  do
    mushroom = Word.find_by word: 'mushroom'
    mushroom.definitions.delete_all
    assert_empty mushroom.definitions
    Word.init_definition 'mushroom'
    mushroom = Word.find_by word: 'mushroom'
    refute_empty mushroom.definitions
  end

  test "count words added by tester"  do
    @session_user_id = User.find_by(uid: 199).id.to_s
    num = Word.count_words @session_user_id
    assert num > 1, "Hey! Tester should have added more than one word."
  end

  test "should respond to struct2hash" do
    assert Word::Helpers.respond_to?('struct2hash')
  end
end
