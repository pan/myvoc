class CamdictWorker
  include Sidekiq::Worker

  # retrieve the rawhtml for the +word+ and init its definition,
  # associate the user id string +idstr+ with this +word+
  def perform(idstr, word)
    init_required = false
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
        init_required = true
      else
        @word.delete
      end
    elsif @word.definitions.empty?
      init_required = true
    else
      User.associate(idstr, @word)
    end
    if init_required
      Word.init_definition word
      User.associate(idstr, @word)
    end
  end

end
