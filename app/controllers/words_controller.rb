class WordsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.where(user_id: current_user).first!
    words = params[:words]

    submission = SubmissionCreator.new(player, words)
    submission.make!

    if submission.correct?
      player.advance_stage!

      if game.finished?
        render json: {
          submissionResult: "gameFinished"
        }

      else
        render json: {
          submissionResult: "tilesDealt",
          letters: game.tiles.last(2).map(& :value),
          message: "nailed it boy"
        }
      end
    else
      render json: {
        submissionResult: "incompleteSubmission",
        message: "You would make an awful word smith rookie"
      }
    end
  end
end
