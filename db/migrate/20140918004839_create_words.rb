class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :string
      t.belongs_to :player
      t.timestamps
    end
  end
end
