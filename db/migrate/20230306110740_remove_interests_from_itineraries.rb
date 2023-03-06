class RemoveInterestsFromItineraries < ActiveRecord::Migration[7.0]
  def change
    remove_column :itineraries, :interests, :string
  end
end
