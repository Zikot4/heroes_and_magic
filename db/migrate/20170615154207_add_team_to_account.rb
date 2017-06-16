class AddTeamToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :team, :integer,        default: 1
  end
end
