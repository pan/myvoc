require 'test_helper'

class ExampleTest < ActiveSupport::TestCase
  def setup
    film = Word.find_by word: 'film'
    @example = film.definitions[0].explanations.first.examples[0]
  end

  test "method meaning" do
    expected_sentence = "What's your favourite film?"
    assert_equal expected_sentence, @example.sentence
  end
end

