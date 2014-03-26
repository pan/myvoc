class WordsController < ApplicationController
  before_action :set_word, only: [:show, :destroy]
  before_action :authenticate, only: [:create, :destroy]
  respond_to :html, :json

  def index
    @words = Word.search params[:search]
    @words = @words.desc(:updated_at).page params[:page]
    @matched = (Word.where word: params[:search]).exists?
    session[:word] = params[:search] if @matched
    @definitions = Word.get_defs (session[:word] || 'popular')
    @word_count = Word.count
  end

  def show
    @word = Word.find(params[:id])
    session[:word] = @word.word
    @definitions = @word.definitions
    render partial: 'definition', layout: false
  end

  def create
    word = params[:search].squish
    jid = CamdictWorker.perform_async word
    redirect_to words_path, notice: jid ? 
      "Job(id:#{jid}) should be completed in a minute." : "Job not created."
  end

  def destroy
    @word.destroy
    respond_with @word
  end

  def suggested
    @words = Word.search params[:term]
    list = @words.map {|w| w.word }
    respond_with list
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:word)
  end

end
