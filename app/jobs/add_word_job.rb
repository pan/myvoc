# frozen_string_literal: true

# adding new word in a job
class AddWordJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    user_id, word = job.arguments
    task = clean_job(user_id)
    msg = feedback(task, word)
    ActionCable.server.broadcast 'word:added:', word: msg
  end

  def perform(*args)
    user_id, word, save_raw = args
    Word.add_asso(user_id, word, save_raw: save_raw)
  end

  private

  def clean_job(user_id)
    User.i(user_id).tasks.each do |t|
      return t if t.remove(job_id)
    end
    false
  end

  def feedback(task, word)
    if task && task.done?
      task.destroy
      'done'
    else
      word
    end
  end
end
