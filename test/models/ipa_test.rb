require 'test_helper'

class IPATest < ActiveSupport::TestCase
  def setup
    film = Word.find_by word: 'film'
    @ipa = film.definitions[1].ipa
  end

  test "fields" do
    film_packed_ipa = [102, 618, 108, 109]
    assert_equal film_packed_ipa, @ipa.uk.unpack('U*')
    assert_equal film_packed_ipa, @ipa.us.unpack('U*')
    assert_nil @ipa.k
  end
end
