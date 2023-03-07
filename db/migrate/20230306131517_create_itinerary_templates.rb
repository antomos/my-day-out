class CreateItineraryTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :itinerary_templates do |t|

      t.timestamps
    end
  end
end
