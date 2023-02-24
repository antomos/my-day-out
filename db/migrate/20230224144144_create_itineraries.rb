class CreateItineraries < ActiveRecord::Migration[7.0]
  def change
    create_table :itineraries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :start_time
      t.string :start_address
      t.string :user_rating
      t.string :vote
      t.string :date
      t.string :end_time
      t.string :budget
      t.string :interests


      t.timestamps
    end
  end
end
