# frozen_string_literal: true

# the notice channel when user connects, it subscibes to batch words added
# notification service
class NoticeChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'word:added:'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
