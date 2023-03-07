class PopulatePlace < ApplicationRecord
  def initialize (place_template = {})
    @event_details = place_template[:event_details]
    @search_place_details= place_template[:search_place_details]
    @place_details = place_template[:place_details]
  end

  def perform
    new_place
  end

  private

  def new_place
    place = Place.new

    place.name = @search_place_details[:name]
    place.details_formatted_address = @place_details["result"]["formatted_address"]
    place.search_types = @search_place_details[:types]
    place.search_rating = @search_place_details[:rating]
    place.search_user_ratings_total = @search_place_details[:user_ratings_total]
    place.search_photo_reference = @search_place_details[:photo_reference]
    place.search_place_details_id = @search_place_details[:place_id]
    place.details_overview = @place_details["result"]["editorial_summary"]["overview"] if @place_details["result"]["editorial_summary"]
    place.details_formatted_phone_number = @place_details["result"]["formatted_phone_number"]
    place.details_opening_hours_periods = @place_details["result"]["opening_hours"]
    place.search_price_level = @search_place_details[:price_level]
    place.details_reviews = @place_details["result"]["reviews"]
    place.details_website = @place_details["result"]["website"]
    place.details_wheelchair_accessible_entrance = @place_details["result"]["wheelchair_accessible_entrance"]
    place.details_url = @place_details["result"]["url"]
    place.search_geometry_location = @search_place_details[:location]
    place.details_serves_vegetarian_food = @place_details["result"]["serves_vegetarian_food"]

    place.save!

    place
  end
end
