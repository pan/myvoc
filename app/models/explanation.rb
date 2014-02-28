class Explanation
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :definition
  embeds_many :examples

  field :level
  field :synonym
  field :opposite
  field :meaning
  field :usage    # todo: which word has this field?
  field :region
  field :gc

end
