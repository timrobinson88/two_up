class WordsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.where(user_id: current_user).first!
    words = params[:words]

    begin
      submission = CreateSubmission.new(player, words)
      result = submission.make!
      render json: {
        submissionResult: result,
        letters: game.tiles.last(2).map(& :value),
      }
    rescue Exception => e
      render json: {
        submissionResult: "save failure",
        errorMessage: "#{e.message}"
      }
    end
  end
end
