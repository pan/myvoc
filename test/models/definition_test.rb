require 'test_helper'

class DefinitionTest < ActiveSupport::TestCase
  def setup
    film = Word.find_by word: 'film'
    @first_definition = film.definitions.first
  end

  test "fields" do
    assert_equal "film_1", @first_definition.entry_id
    assert_equal "noun", @first_definition.part_of_speech
    assert_equal "http://dictionary.cambridge.org/media/british/uk_pron/" + 
      "u/ukf/ukfil/ukfill_007.mp3", @first_definition.pronunciation["uk"]["mp3"]
    assert_equal "MOVING PICTURES", @first_definition.guided
    assert_nil @first_definition.is_idiom
    assert_nil @first_definition.region
    assert_nil @first_definition.usage
    assert_equal "C or U", @first_definition.gc
  end
end
