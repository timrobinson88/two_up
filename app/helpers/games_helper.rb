module GamesHelper
  def user_emails(game)
    game.players.map{ |player| player.user.email}.join(", ")
  end

  def winning_words(game)
    game.winner.words.pluck(:string).join(", ")
  end
end
