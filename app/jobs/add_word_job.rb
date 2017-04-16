# frozen_string_literal: true

# adding new word in a job
class AddWordJob < ApplicationJob
  queue_as :default

  def perform(*args)
    user_id, word, save_raw = args
    Word.add_asso(user_id, word, save_raw: save_raw)
  end
end
