class CreateBuffs < ActiveRecord::Migration[5.0]
  def change
    create_table :buffs do |t|
      t.string :name
      t.string :variety
      t.integer :unit_id

      t.timestamps
    end
  end
end
