# frozen_string_literal: true

# the notice channel when user connects, it subscibes to batch words added
# notification service
class NoticeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "word:added:#{current_user.id.to_s}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
