class Definition
  include Mongoid::Document
  include Mongoid::Timestamps

  embeded_in :word

  field :part_of_speech
  field :guide
  field :isidiom, type: Boolean
  field :region
  field :usage
  field :gc

  embeds_one :ipa
  embeds_many :explanations
end
