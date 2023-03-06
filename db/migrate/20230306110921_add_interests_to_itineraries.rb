class AddInterestsToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :interests, :text, array: true, default: []
  end
end
