class AddDelayToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :delay, :integer, default: 0
  end
end
