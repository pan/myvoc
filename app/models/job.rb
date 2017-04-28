# frozen_string_literal: true

# when adding a new word in a background job, save its job_id
class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :task
  field :job_id
  field :word
end
