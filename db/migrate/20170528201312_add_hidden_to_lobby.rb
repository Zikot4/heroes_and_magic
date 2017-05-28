class AddHiddenToLobby < ActiveRecord::Migration[5.0]
  def change
    add_column :lobbies, :hidden, :boolean,       default: false
  end
end
