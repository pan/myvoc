class IPA
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uk
  field :k
  field :us
  field :s

  embeded_in :definition
end
