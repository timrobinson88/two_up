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

  def refresher
    @game = Game.find(params[:gameId])
    if @game.finished || @game.started.to_s != params[:started]
      render json: {actionRequired: 'reload'}
    elsif @game.tiles.count != params[:tileCount].to_i
      tiles = tiles_to_add(@game, @game.tiles.count, params[:tileCount].to_i)
      render json: { actionRequired: 'addTiles', tiles: tiles }
    else
      render json: { actionRequired: 'none' }
    end
  end

  private

  def user_logged_in?
    redirect_to new_user_session_path if !user_signed_in?
  end

  def refresh_required?
    params[:tileCount].to_i != @game.tiles.count
  end

  def tiles_to_add(game, game_tile_count, current_view_tile_count)
    number_of_tiles_to_add = (game_tile_count - current_view_tile_count)
    tiles = game.tiles.last(number_of_tiles_to_add).map(& :value)
    tiles
  end
end
