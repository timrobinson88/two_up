class Game < ActiveRecord::Base
  has_many :tiles, dependent: :destroy 
  has_many :players, dependent: :destroy
  belongs_to :winner, class_name: "Player"

  def deal_tiles
    2.times { tiles.create }
  end

  def deal_initial_tiles
    12.times { tiles.create }
  end

  def start!
     self.started = true
  end

  def add_player!
      players.create!(user_id: 1)
  end

  def finish!(winner_id)
    self.finished = true
    self.winner_id = winner_id
  end
end
