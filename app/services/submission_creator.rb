class SubmissionCreator
  attr_accessor :player, :new_words

  def initialize(player, new_words)
    @player = player
    @new_words = new_words
  end

  def make!
    old_words = player.words.map(&:string)
    words_to_make = new_words - old_words
    words_to_destroy = old_words - new_words
    Word.transaction do
      player.words.where(string: words_to_destroy).destroy_all
      words_to_make.each { |string| player.words.create!(string: string) } 
    end
  end

  def correct?
    @player.submission_correct?
  end
end