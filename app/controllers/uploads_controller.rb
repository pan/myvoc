# frozen_string_literal: true

# uploaded file processing by background jobs
class UploadsController < ApplicationController
  before_action :authenticate, only: :upload

  def upload
    @message = verify_param
    @message = add_to_job if @message.empty?
  end

  private

  def add_to_job
    words = clean(filetext)
    if words
      upload_task(words)
      "#{filename} uploaded, adding #{words.size} words..."
    else
      "No valid word found in the uploaded file #{filename}."
    end
  end

  def upload_task(words)
    job_ids = words.map do |word|
      [AddWordJob.perform_later(uid, word).job_id, word]
    end
    current_user.tasks.create job: job_ids.to_h
  end

  def filetext
    File.read(uploaded.path, mode: 'r:bom|utf-8')
  end

  def filename
    uploaded.original_filename
  end

  def verify_param
    return 'Please select a text file to upload.' unless uploaded
    if uploaded.content_type != 'text/plain'
      'Only plain text file can be uploaded.'
    elsif !(1..max_size).cover?(uploaded.size)
      "File size: #{uploaded.size} is not in the allowed range [1,10M]."
    else ''
    end
  end

  def uploaded
    params[:list]
  end

  def max_size
    10.megabytes
  end

  # strip blank chars at the beginning or the end of a line.
  # delete the invalid lines if it is not started with a letter.
  # return the unique words list or nil if no valid word found
  def clean(text)
    words = text.split(/\r?\n/)
    words.select! do |w|
      w.strip!
      w =~ /^[a-zA-Z]/
    end
    words.uniq unless words.empty?
  end
end
