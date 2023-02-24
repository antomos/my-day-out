class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :details_formatted_address
      t.string :search_types
      t.string :search_rating
      t.string :search_user_ratings_total
      t.string :search_photo_reference
      t.string :search_place_deteails_id
      t.string :details_overview
      t.string :details_formatted_phone_number
      t.string :details_opening_hours_periods
      t.string :search_price_level
      t.string :details_reviews
      t.string :details_website
      t.string :details_wheelchair_accessible_entrance
      t.string :details_url
      t.string :search_geometry_location
      t.string :details_serves_vegeterian_food

      t.timestamps
    end
  end
end
