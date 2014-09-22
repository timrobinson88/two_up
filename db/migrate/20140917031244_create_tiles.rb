class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|

      t.string :value
      t.belongs_to :game
      t.timestamps
    end
  end
end
