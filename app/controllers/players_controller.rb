class PlayersController < ApplicationController
  def create
    @player = Player.create!(game_id: player_params, user: current_user)
    redirect_to game_path(@player.game)
  end

  private

  def player_params
    params.require(:game_id)
  end

end
