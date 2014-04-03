class WordsController < ApplicationController
  before_action :set_word, only: [:show, :destroy]
  before_action :authenticate, only: [:create, :destroy]
  before_action :search_word, only: [:index, :suggested]
  respond_to :html, :json

  def index
    @words = @words.desc(:updated_at).page params[:page]
    @matched = (@words.where word: params[:term]).exists?
    session[:word] = params[:term] if @matched
    @definitions = Word.get_defs session[:word] || random_word
    @word_count = Word.count_words session[:user_id]
  end

  def show
    @word = Word.find(params[:id])
    session[:word] = @word.word
    @definitions = @word.definitions
    render partial: 'definition', layout: false
  end

  def create
    word = params[:term].squish
    jid = CamdictWorker.perform_async session[:user_id], word
    redirect_to words_path, notice: jid ? 
      "Job(id:#{jid}) should be completed in a minute." : "Job not created."
  end

  def destroy
    @words = User.find(session[:user_id]).words
    @words.delete(@word)
    render json: {id: @word.id.to_s}
  end

  def suggested
    list = @words.map {|w| w.word }
    respond_with list
  end

  private

  # set the words scope to those belonging to current user if logged in, 
  # otherwise the scope is all words in DB
  def search_word
    if session[:user_id]
      user = User.find(session[:user_id])
      @words = user.words if user
      if @words
        @words = @words.search params[:term] 
      else
        @words = Word.search params[:term] 
      end
    else
      @words = Word.search params[:term]
    end
  end

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:word)
  end

  # definitions from a random word
  def random_word
    c = @words.count - 1
    i = rand(0..c)
    @words[i].definitions if i && @words[i]
  end

end
