class CreateJoinTableLobbyAccount < ActiveRecord::Migration[5.0]
  def change
    create_join_table :lobbies, :accounts do |t|
      # t.index [:lobby_id, :account_id]
      # t.index [:account_id, :lobby_id]
    end
  end
end
