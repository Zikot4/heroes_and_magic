class AddLobbyIdToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :lobby_id, :integer
  end
end
