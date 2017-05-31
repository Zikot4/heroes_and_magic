class CreateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.integer  :lobby_id
      t.string   :variety
      t.text     :body
      t.timestamps
    end
  end
end
