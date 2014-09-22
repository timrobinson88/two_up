class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :started, default: false
      t.boolean :finished, default: false
      t.references :winner
      t.integer :max_tile_count, default: 16
      t.timestamps
    end
  end
end
