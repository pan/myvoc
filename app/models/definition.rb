class Definition
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :word

  field :entry_id
  field :part_of_speech
  field :guided
  field :is_idiom, type: Boolean
  field :region
  field :usage
  field :gc

  embeds_one :ipa, class_name: "IPA"
  embeds_many :explanations
end
