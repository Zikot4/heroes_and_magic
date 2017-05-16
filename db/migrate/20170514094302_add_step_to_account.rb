class AddStepToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :current_step, :boolean,      default: false
  end
end
