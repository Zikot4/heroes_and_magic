class AddDefeatToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :defeat, :boolean,            default: false
  end
end
