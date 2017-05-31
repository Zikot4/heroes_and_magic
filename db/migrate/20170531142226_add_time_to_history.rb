class AddTimeToHistory < ActiveRecord::Migration[5.0]
  def change
    add_column :histories, :time, :text
  end
end
