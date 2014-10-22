class CreateGame
  def make(current_user)
    Game.transaction do
      game = Game.create!
      game.players.create!(user: current_user)

      game
    end
  end
end