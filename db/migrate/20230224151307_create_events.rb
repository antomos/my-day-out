class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :itinerary, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.string :start_time
      t.string :end_time


      t.timestamps
    end
  end
end
