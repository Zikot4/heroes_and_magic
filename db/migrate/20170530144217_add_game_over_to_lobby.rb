class AddGameOverToLobby < ActiveRecord::Migration[5.0]
  def change
    add_column :lobbies, :game_over, :boolean,  default: false
  end
end
