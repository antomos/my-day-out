class AddOpenNowToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :open_now, :boolean
  end
end
