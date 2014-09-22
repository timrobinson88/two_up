
class GameMaker
  def make
    Game.transaction do
      game = Game.create!
      game.players.create!(user_id: 5)
      game.deal_initial_tiles

      game
    end
  end
end