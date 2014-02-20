class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @words = Word.search params[:search]
    @matched = (Word.where word: params[:search]).exists?
  end

  def show
  end

  def new
    @word = Word.new
  end

  def edit
  end

  def create
    @word = Word.new word_params
    begin 
      raw_definitions = Rawhtml.fetch @word.word
      raw_definitions.each { |html_def| 
        html_def.each_pair { |key, value|
          @word.rawhtmls.build entry_id: key, htmldef: value
        }
      }
    rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED => e
      respond_to do |format|
        format.html { redirect_to words_path, notice: e.message }
        format.json { render json: e.message, status: :unprocessable_entity }
      end
      return
    end 

    respond_to do |format|
      if @word.save
        format.html { redirect_to words_path, notice: "#{@word.word} added"}
        format.json { render action: 'show', status: :created, location: @word }
      else
        format.html { redirect_to words_path, notice: @word.errors }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
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
