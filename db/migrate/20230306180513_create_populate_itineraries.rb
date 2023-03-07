class CreatePopulateItineraries < ActiveRecord::Migration[7.0]
  def change
    create_table :populate_itineraries do |t|

      t.timestamps
    end
  end
end
