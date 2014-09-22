class GamesController < ApplicationController

  def new
  end

  def create
    @game = GameMaker.new.make
    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
  end

  def two_up
    @game = Game.find(params[:id])
    @tile = @game.tiles.create!
    
  end
end
