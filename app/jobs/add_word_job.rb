# frozen_string_literal: true

# adding new word in a job
class AddWordJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    user_id, word = job.arguments
    task = clean_job
    ActionCable.server.broadcast to_queue(user_id), word: word
    clean_task(user_id, task)
  end

  def perform(*args)
    user_id, word, save_raw = args
    Word.add_asso(user_id, word, save_raw: save_raw)
  end

  private

  def clean_job
    job = Job.find_by(job_id: job_id)
    task = job.task
    job.destroy
    task
  end

  def clean_task(user_id, task)
    return unless task.reload.done?
    task.destroy
    ActionCable.server.broadcast to_queue(user_id), word: 'done'
  end

  def to_queue(user_id)
    "word:added:#{user_id}"
  end
end
