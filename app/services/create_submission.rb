class CreateSubmission < Struct.new(:player, :new_words)
  def make!
    reconstruct_player_words
    process_submission
  end

  private

  def reconstruct_player_words
    words_to_make = new_words - player.words.pluck(:string)
    words_to_destroy = player.words.where.not(:string => new_words)
    Word.transaction do
      words_to_destroy.each do |word|
        word.destroy!
      end
      player.words.reset
      words_to_make.each { |string| player.words.create!(string: string) }
    end
  end

  def process_submission
    if player.submission_correct?
      player.advance_stage!

      if player.game.finished?
        "gameFinished"
      else
        "tilesDealt"
      end
    else
      "incompleteSubmission"
    end
  end
end
