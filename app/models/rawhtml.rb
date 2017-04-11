# frozen_string_literal: true

# save word raw html document
class Rawhtml
  include Mongoid::Document
  include Mongoid::Timestamps

  field :h, as: :htmldef, type: String

  belongs_to :word
end
