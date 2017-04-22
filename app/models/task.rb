# frozen_string_literal: true

# background job management, a uploading task may create several active jobs,
# store these jobs ids when upload begins and remove it once it is finished.
class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :job, type: Hash # job_id => word

  def remove(job_id)
    save if job.delete job_id
  end

  def done?
    job.keys.size.zero?
  end
end
