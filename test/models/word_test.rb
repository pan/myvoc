# frozen_string_literal: true

require 'test_helper'

class WordTest < ActiveSupport::TestCase
  test 'ips schema' do
    is = Word.send(:ipa_schema, uk: 'god', us: 'gud')
    assert is.key?(:ipa_h)
  end

  test 'search should get all words' do
    all_words = Word.search
    assert_equal Word.count, all_words.size, 'Not all words are got'
  end

  test 'search should support regex' do
    words_begin_with_m = Word.search('^m')
    assert_equal 2, words_begin_with_m.size,
      "We have populated two words beginning with letter m, haven't we?"
  end

  test 'should init definition' do
    skip 'not implemented yet'
    mushroom = Word.find_by word: 'mushroom'
    mushroom.update(meaning: [])
    assert_empty mushroom.meaning
    Word.init_definition 'mushroom'
    mushroom.reload
    refute_empty mushroom.meaning
  end

  test 'count words added by tester'  do
    num = Word.count_words tester_amanda.id.to_s
    assert num > 1, 'Hey! Tester should have added more than one word.'
  end
end
