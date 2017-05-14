class AddFieldsToLobby < ActiveRecord::Migration[5.0]
  def change
    add_column :lobbies, :user_id, :integer
    add_column :lobbies, :game_mode, :integer,          default: 3
    add_column :lobbies, :everyone_is_ready, :boolean,  default: false
  end
end
