class AddLapToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :lap, :integer,         default: 0
  end
end
