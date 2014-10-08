class GamesController < ApplicationController
  before_filter :user_logged_in?

  def index
    @games = Game.where(started: false)
    @player = Player.new
  end

  def new
  end

  def create
    @game = GameCreator.new.make(current_user)
    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.players.where(user: current_user).first
    render 'finished' if @game.finished?
  end

  def start
    @game = Game.find(params[:game_id])
    @game.start!

    redirect_to @game
  end

  def refresh
    puts params
    @game = Game.find(params[:gameId])
    if Game.finished
    render json: { actionRequired: refresh_required?.to_s}
  end

  private

  def user_logged_in?
    redirect_to new_user_session_path if !user_signed_in?
  end

  def refresh_required?
    params[:tileCount].to_i != @game.tiles.count || @game.finished.to_s != params[:finished]
  end
end