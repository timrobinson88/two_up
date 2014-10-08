class AddGameIdIndexToTile < ActiveRecord::Migration
  def change
    add_index :tiles, :game_id
  end
end
