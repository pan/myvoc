class Word
  include Mongoid::Document
  include Mongoid::Timestamps

  field :word, type: String

  has_many :rawhtmls, autosave: true
  embeds_many :definitions

  # search all words that include +word+ when +word+ is supplied, otherwise
  # return all words.
  def self.search(word)
    if word
      where word: Regexp.new(word)
    else
      all
    end
  end

  # normalize +word+ definitions from rawhtmls
  def self.normalize_definition(word) 
    require 'camdict'

    w = self.find_by word: word
    w.rawhtmls.each { |r|
      cw = Camdict::Definition.new(word, r)
    }
  end
end
