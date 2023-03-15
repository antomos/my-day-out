class AddRemovedToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :removed, :boolean, default: false
  end
end
