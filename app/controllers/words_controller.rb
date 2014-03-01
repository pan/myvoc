class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @words = Word.search params[:search]
    session[:word] = params[:search] if params[:search]
    @matched = (Word.where word: params[:search]).exists?
    @definitions = Word.get_defs (session[:word] || 'popular')
  end

  def show
    @word = Word.find(params[:id])
    session[:word] = @word.word
    @definitions = @word.definitions
    render partial: 'definition', layout: false
  end

  def new
    @word = Word.new
  end

  def edit
  end

  def create
    @word = Word.new word_params
    CamdictWorker.perform_async @word.word

    if @word.save
      session[:word] = @word.word
      redirect_to words_path, notice: "#{@word.word} added"
    else
      redirect_to words_path, notice: @word.errors
    end
  end

  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: "\'#{@word.word}\' updated" }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @word.destroy
    respond_with @word
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:word)
  end

end
