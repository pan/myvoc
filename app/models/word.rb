# frozen_string_literal: true

# word model
class Word
  include Mongoid::Document
  include Mongoid::Timestamps

  field :w, as: :word, type: String
  field :m, as: :meaning, type: Array
  field :i, as: :ipa, type: String
  field :ih, as: :ipa_h, type: Hash
  field :p, as: :pronunciation, type: Hash

  has_one :rawhtml, autosave: true, dependent: :delete

  class << self
    def i(word)
      find_by(word: word) if exist?(word)
    end

    def exist?(word)
      word && search(word).exists?
    end

    def add_asso(user_id, word, save_raw: false)
      aword = exist?(word) ? i(word) : make(word, save_raw: save_raw)
      user = User.i(user_id)
      if aword && !user.associated?(word)
        user.associate(aword)
        aword
      end
    rescue Camdict::WordNotFound
      false
    end

    def make(wd, save_raw: false)
      cw = Camdict::Word.new(wd)
      nw = new word: wd
      nw.build_rawhtml(htmldef: cw.raw_definitions) if save_raw
      data = cw.show
      ipa = data.delete(:ipa)
      nw if nw.update data.merge(ipa_schema(ipa))
    end

    # search all words that include +word+ when +word+ is supplied, otherwise
    # return all words.
    def search(word = nil)
      word ? where(word: Regexp.new(word)) : all
    end

    # count how many words a user +uid+ has added if user's logged in, otherwise
    # count how many words in db.
    def count_words(uid)
      if uid
        u = User.find uid
        u.words.count if u
      else
        count
      end
    end

    # initialize definitions from rawhtmls for the +word+
    def init_definition(word); end

    private

    def ipa_schema(ipa)
      if ipa.is_a?(String)
        { ipa: ipa }
      else
        { ipa_h: ipa }
      end
    end
  end
end
