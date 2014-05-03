class UploadsController < ApplicationController
  before_action :authenticate, only: :upload

  def upload
    max_size = 10.megabytes
    message = ""
    uploaded = params[:list]
    if uploaded
      if uploaded.content_type != 'text/plain'
        message = "Only plain text file can be uploaded."
      elsif !(1..max_size).cover?(uploaded.size) 
        message = "Your file size: #{uploaded.size} is not in the allowed" +
         "range [1,10M]."
      end
    else
      message = "You didn't select any file to upload."
    end
    unless message.empty?
      redirect_to root_path, notice: message
      return
    end
    filename = uploaded.original_filename
    text = uploaded.read
    if words = clean(text)
      count = 0
      words.each { |word|
        jid = CamdictWorker.perform_async session[:user_id], word
        count += 1 if jid
      }
      message = 
        "#{filename} uploaded, adding #{words.size} words by #{count} jobs."
    else
      message = "No valid word found in the uploaded file #{filename}."
    end
    redirect_to root_path, notice: message
  end

  protected

  # strip blank chars at the beginning or the end of a line. 
  # delete the invalid lines if it is not started with a letter.
  # return the unique words list or nil if no valid word found
  def clean text
    words = text.split /\r?\n/
    words.reject! { |w|
      w.strip!
      w !~ /^[a-zA-Z]/
    }
    return words.uniq unless words.empty?
  end

end
