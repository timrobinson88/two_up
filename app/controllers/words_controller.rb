class WordsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.where(user_id: current_user).first!
    words = params[:words]

    submission = SubmissionCreator.new(player, words)
    result = submission.make!

        render json: {
          submissionResult: result,
          letters: game.tiles.last(2).map(& :value),
        }
  end
end
