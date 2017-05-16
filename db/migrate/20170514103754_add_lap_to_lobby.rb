class AddLapToLobby < ActiveRecord::Migration[5.0]
  def change
    add_column :lobbies, :lap, :integer,           default: 0
  end
end
