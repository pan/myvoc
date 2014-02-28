class Example
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :explanation

  field :usage
  field :sentence 

end
