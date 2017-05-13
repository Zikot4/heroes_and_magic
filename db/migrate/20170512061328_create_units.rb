class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.integer :account_id
      t.string :variety
      t.integer :hp

      t.timestamps
    end
  end
end
