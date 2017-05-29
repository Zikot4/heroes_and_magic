class AddFieldToUnit < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :dead, :boolean,         default: false
  end
end
