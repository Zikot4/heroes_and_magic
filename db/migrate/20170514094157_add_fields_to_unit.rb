class AddFieldsToUnit < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :under_attack, :integer,  default: nil
    add_column :units, :lap, :integer,           default: 0   
  end
end
