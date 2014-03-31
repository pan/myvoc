class TestWorker
  include Sidekiq::Worker

  def perform(id, wid)
    word = Word.find wid
    logger.info "From-TestWorker: word #{word.class}"
    logger.info "From-TestWorker: wrod #{word.word}"
    user = User.find id
    logger.info "From-TestWorker: #{user.class}"
    logger.info "From-TestWorker: #{user.name}"
  end

end
