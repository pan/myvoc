module WordsHelper
  # map the symbol of level to its name
  def level_name symbol
    name_symbol = {
      A1: "Beginner",       A2: "Elementary",
      B1: "Intermediate",   B2: "Upper-Intermediate",
      C1: "Advanced",       C2: "Proficiency"
    }
    name_symbol[symbol.to_sym] if symbol
  end

  # convert an +ipa+ obj to an ipa string
  def ipastr ipa
    "/#{ipa}/" if ipa
  end

  # how many words
  def how_many number
    if number < 1
      "No word in DB" 
    else
      "[#{number}]"
    end
  end

  # give current word a css class "current"
  def current word
    " current" if word == session[:word]
  end

  # return those fields that have a non empty value from +ha+, which may be a
  # Hash or Array
  def dry ha
    if ha.is_a? Hash
      ha.keep_if { |key, value|
        value
      }
    elsif ha.is_a? Array
      ha.keep_if { |e| e }
    end
  end
end
