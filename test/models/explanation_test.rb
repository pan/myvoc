require 'test_helper'

class ExplanationTest < ActiveSupport::TestCase
  def setup
    film = Word.find_by word: 'film'
    @explanation = film.definitions[0].explanations.first
  end

  test "method meaning" do
    expected_meaning = "a series of moving pictures, usually shown in " + 
      "a cinema or on television and often telling a story: "
    assert_equal expected_meaning, @explanation.meaning
  end
end
