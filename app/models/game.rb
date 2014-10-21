class Game < ActiveRecord::Base
  has_many :tiles, dependent: :destroy 
  has_many :players, dependent: :destroy
  belongs_to :winner, class_name: "Player"

  def deal_tiles!
    transaction do
      2.times { tiles.create! }
    end
  end

  def available_tiles
    tiles.map(&:value).sort
  end

  def start!
    transaction do
      update!(started: true)
      deal_initial_tiles!
    end
  end
  
  def finish_and_assign_winner!(winning_player)
    self.finished = true
    self.winner = winning_player
    save!
  end

  def advance_stage!(player)
    if all_tiles_used?
      finish_and_assign_winner!(player) 
    else
      deal_tiles!
    end
  end

  private
  def all_tiles_used?
    tiles.count >= max_tile_count
  end

  def deal_initial_tiles!
    12.times { tiles.create! }
  end
end
