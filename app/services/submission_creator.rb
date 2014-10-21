class SubmissionCreator
  #rename 
  attr_accessor :player, :new_words

  def initialize(player, new_words)
    @player = player
    @new_words = new_words
  end

  def make!
    reconstruct_player_words(@player, @new_words)
    return process_submission(@player)
  end

  def reconstruct_player_words(player, new_words)
    old_words = player.words
    words_to_make = new_words - old_words.map(&:string)
    words_to_destroy = old_words.select { |word| new_words.exclude? word.string }
    Word.transaction do
      words_to_destroy.each do |word|
        word.destroy!
      end
      player.words.reset
      words_to_make.each { |string| player.words.create!(string: string) } 
    end
  end

  def process_submission(player)
    if player.submission_correct?
      player.advance_stage!

      if player.game.finished?
        return "gameFinished"
      else
        return "tilesDealt"
      end
    else
      return "incompleteSubmission"
    end
  end
end



