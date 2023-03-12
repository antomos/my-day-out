class CreateSetTravelTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :set_travel_times do |t|

      t.timestamps
    end
  end
end
