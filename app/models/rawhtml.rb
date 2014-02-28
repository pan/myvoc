class Rawhtml
  include Mongoid::Document
  include Mongoid::Timestamps

  field :entry_id, type: String 
  field :htmldef, type: String

  belongs_to :word

  def self.fetch word
    Camdict::Client.new.html_definition(word)
  end

end
