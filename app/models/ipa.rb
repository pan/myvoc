class IPA
  include Mongoid::Document

  field :uk
  field :k, type: Array
  field :us
  field :s, type: Array

  embedded_in :definition
end
