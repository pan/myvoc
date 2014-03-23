class CamdictWorker
  include Sidekiq::Worker

  # retrieve the rawhtml for the +word+ and init its definition
  def perform word
    @word = Word.find_by word: word
    unless @word
      @word = Word.new word: word
      @word.save
    end
    if @word.rawhtmls.empty?
      @raw_definitions = Rawhtml.fetch word
      unless @raw_definitions.empty?
        @raw_definitions.each { |html_def| 
          html_def.each_pair { |key, value|
            @word.rawhtmls.build entry_id: key, htmldef: value
          }
        }
        @word.save
        Word.init_definition word
      else
        @word.delete
      end
    end
  end

end
