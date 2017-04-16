# frozen_string_literal: true

# the main controller of this app
class WordsController < ApplicationController
  before_action :set_word, only: %i[show destroy]
  before_action :authenticate, only: %i[create destroy]
  before_action :search_word, only: %i[index suggested]
  respond_to :html, :json

  def index
    @words = @words.desc(:updated_at).page params[:page]
    set_session_word
    @word = Word.i(session[:word]) || rand_word
    @word_count = Word.count_words uid
  end

  def show
    session[:word] = @word.word
    render partial: 'definition'
  end

  def create
    word = params[:term].squish
    if Word.add_asso(uid, word)
      session[:word] = word
      msg = "#{word} added"
    else
      msg = "#{word} not found"
    end
    redirect_to words_path, notice: msg
  end

  def destroy
    @words = current_user.words
    @words.delete(@word)
    render json: { id: @word.id.to_s }
  end

  def suggested
    list = @words.map(&:word)
    respond_with list
  end

  private

  def set_session_word
    matched = (@words.where word: params[:term]).exists?
    session[:word] = params[:term] if matched
  end

  # set the words scope to those belonging to current user if logged in,
  # otherwise the scope is all words in DB
  def search_word
    @words =
      if login? && current_user.words.exists?
        current_user.words.search params[:term]
      else
        Word.search params[:term]
      end
  end

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:word)
  end

  # a random word
  def rand_word
    idx = rand(@words.count)
    @words[idx]
  end
end
