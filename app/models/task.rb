# frozen_string_literal: true

# background job management, a uploading task may create several active jobs,
# store the global job ids when upload begins and remove it once it is finished.
# mongodb storage engineer WireTiger supports document level lock for concurrent
# write access, so each job is a document and can be deleted simultaneously.
class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_many :jobs

  def done?
    jobs.count.zero?
  end

  def self.upload(user, words)
    task = user.tasks.create
    uid = user.id.to_s
    words.each do |word|
      bg_job = AddWordJob.perform_later(uid, word)
      task.jobs.create(job_id: bg_job.job_id, word: word)
    end
  end
end
