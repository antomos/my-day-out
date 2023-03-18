class AddSavedToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :saved, :boolean, default: false
  end
end
