class CamdictWorker
  include Sidekiq::Worker

  # retrieve the rawhtml for the +word+ and init its definition
  def perform word
    begin 
      @raw_definitions = Rawhtml.fetch word
      @word = Word.find_by word: word
      @raw_definitions.each { |html_def| 
        html_def.each_pair { |key, value|
          @word.rawhtmls.build entry_id: key, htmldef: value
        }
      }
      @word.save
    rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED => e
      logger.error "#{word} #{e.message}"
      return
    end 
    Word.init_definition word
  end

end
