class RemoveEndtimeFromItineraries < ActiveRecord::Migration[7.0]
  def change
    remove_column(:itineraries, :end_time)
  end
end
