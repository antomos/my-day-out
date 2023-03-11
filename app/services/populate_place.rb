class PopulatePlace < ApplicationRecord
  def initialize (place_template = {})
    # @event_details = place_template[:event_details]
    @search_place_details= place_template[:search_place_details]
    @place_details = place_template[:place_details]

  end

  def perform
    new_place
  end

  private

  def new_place
    place = Place.new

    # binding.pry

    ## changed for JSON testing butshould still work
    place.name = @search_place_details[:name] # @place_details["result"]["name"]
    place.details_formatted_address = @place_details["result"]["formatted_address"]
    place.search_types = @place_details["result"]["types"] # @search_place_details[:types]
    place.search_rating = @place_details["result"]["rating"] # @search_place_details[:rating]
    place.search_user_ratings_total = @place_details["result"]["user_ratings_total"] # @search_place_details[:user_ratings_total]
    place.search_photo_reference =  @search_place_details[:photo_reference]
    ## changed for JSON testing butshould still work
    place.search_place_details_id =  @search_place_details[:place_id] # @place_details["result"]["place_id"] #
    place.details_overview = @place_details["result"]["editorial_summary"]["overview"] if @place_details["result"]["editorial_summary"]
    place.details_formatted_phone_number = @place_details["result"]["formatted_phone_number"]
    place.details_opening_hours_periods = @place_details["result"]["opening_hours"]
    place.search_price_level = @place_details["result"]["price_level"] #  @search_place_details[:price_level]
    ## Commented out for testing
    place.details_reviews = @place_details["result"]["reviews"]
    place.details_website = @place_details["result"]["website"]
    place.details_wheelchair_accessible_entrance = @place_details["result"]["wheelchair_accessible_entrance"]
    place.details_url = @place_details["result"]["url"]
    place.search_geometry_location = "#{@place_details["result"]["geometry"]["location"]["lat"]},#{@place_details["result"]["geometry"]["location"]["lng"]}" # @search_place_details[:location]
    place.details_serves_vegetarian_food = @place_details["result"]["serves_vegetarian_food"]

    # binding.pry

    if @search_place_details[:photo_reference]
      # TEST
      # file = URI.open("https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/City_of_London_skyline_from_London_City_Hall_-_Sept_2015_-_Crop_Aligned.jpg/1280px-City_of_London_skyline_from_London_City_Hall_-_Sept_2015_-_Crop_Aligned.jpg")

      # COMMENTED OUT TO STOP CLOGGING UP CLOUDINARY DIRING DEVELOPMENT
      # NEED TO ADD A GENERIC PHOTO HOSTED ON CLOUDINARY IF NO PHOTO REFERENCE

      # key = ENV["GOOGLE_API_KEY"]
      # file = URI.open("https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&maxheight=800&photo_reference=#{@search_place_details[:photo_reference]}&key=#{key}")
      # place.photo.attach(io: file, filename: "#{@search_place_details[:name]}.png", content_type: "image/png")
    end

    place.save!

    place
  end
end
