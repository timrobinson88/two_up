class SubmissionCreator
  attr_accessor :player, :new_words

  def initialize(player, new_words)
    @player = player
    @new_words = new_words
  end

  def make!
    old_words = @player.words
    words_to_make = new_words - old_words.map(&:string)
    words_to_destroy = old_words.select { |word| new_words.exclude? word.string }
    Word.transaction do
      words_to_destroy.each do |word|
        word.destroy!
      end
      player.words.reset
      words_to_make.each { |string| @player.words.create!(string: string) } 
    end
  end

  def correct?
    @player.submission_correct?
  end
end