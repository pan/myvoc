class Word
  include Mongoid::Document
  include Mongoid::Timestamps

  field :word, type: String

  has_many :rawhtmls, autosave: true, dependent: :delete
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

  # get definitions for the +word+
  def self.get_defs word
    wi = find_by word: word
    wi.definitions if wi
  end

  # initialize definitions from rawhtmls for the +word+ 
  def self.init_definition(word) 
    w = find_by word: word
    return unless w
    excluded = ["_id", "created_at", "updated_at"]
    defields = Definition.fields.keys - excluded - ["entry_id", "pronunciation"]
    w.rawhtmls.each { |r|
      cw = Camdict::Definition.new(word, {r.entry_id => r.htmldef})
      non_empty_fnames = defields.keep_if { |f| eval "cw.#{f}" }
      assign_code = "entry_id: r.entry_id, "
      pronh = Helpers.struct2hash cw.pronunciation
      assign_code += "pronunciation: pronh, "
      non_empty_fnames.each { |f| assign_code += "#{f}: cw.#{f}, "}
      assign_code = "w.definitions.new(#{assign_code})"
      defi = eval assign_code 
      if cw.explanations
        cw.explanations.each { |exp|
          fields = Explanation.fields.keys - excluded
          non_empty_fnames = fields.keep_if { |f| eval "exp.#{f}" }
          assign_code = "defi.explanations.new("
          non_empty_fnames.each { |f| assign_code += "#{f}: exp.#{f}, "}
          assign_code += ")"
          expi = eval assign_code
          if exp.examples
            exp.examples.each { |exa|
              exadata = {}
              if exa.usage
                exadata["usage"] = exa.usage 
              end
              if exa.sentence
                exadata["sentence"] = exa.sentence
              end
              exai = expi.examples.new(exadata)
            }
          end
        }
      end
      if cw.ipa
        fields = IPA.fields.keys - excluded
        non_empty_fnames = fields.keep_if { |f| 
          fvalue = cw.ipa.send(f) 
          !fvalue.empty? if fvalue 
        }
        data = {}
        non_empty_fnames.each { |f| 
          data[f] = cw.ipa.send(f)
        }
        defi.build_ipa data unless data.empty?
      end
    }
    w.save
  end

  module Helpers
    extend WordsHelper
  end
end
