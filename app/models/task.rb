# frozen_string_literal: true

# background job management, a uploading task may create several active jobs,
# store these jobs ids at the beginning and remove it again once it is finished.
class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :job, type: Hash # job_id => true

  def remove(job_id)
    save if job.delete job_id
  end

  def done?
    job.keys.size.zero?
  end
end
