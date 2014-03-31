class Example
  include Mongoid::Document

  embedded_in :explanation

  field :usage
  field :sentence 

end
