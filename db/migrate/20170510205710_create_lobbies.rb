class CreateLobbies < ActiveRecord::Migration[5.0]
  def change
    create_table :lobbies do |t|
      t.string :url
      t.integer :count_of_users

      t.timestamps
    end
  end
end
