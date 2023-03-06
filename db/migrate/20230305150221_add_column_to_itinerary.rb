class AddColumnToItinerary < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :end_time, :string
    add_column :itineraries, :dining_requirements, :string
  end
end
