class CreateRequestPlaceDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :request_place_details do |t|

      t.timestamps
    end
  end
end
