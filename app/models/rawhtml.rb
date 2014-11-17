class Rawhtml
  include Mongoid::Document
  include Mongoid::Timestamps

  field :entry_id, type: String 
  field :htmldef, type: String

  belongs_to :word

  def self.fetch word
    client = Camdict::Client.new "english-chinese-simplified"
    client.html_definition(word)
  end

end
