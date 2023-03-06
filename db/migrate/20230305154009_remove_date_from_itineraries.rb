class RemoveDateFromItineraries < ActiveRecord::Migration[7.0]
  def change
    remove_column :itineraries, :date
    remove_column :itineraries, :start_time
    remove_column :itineraries, :end_time

    add_column :itineraries, :start_time, :time
    add_column :itineraries, :end_time, :time
    add_column :itineraries, :date, :date
  end
end
