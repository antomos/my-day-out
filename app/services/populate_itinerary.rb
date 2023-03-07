require "uri"
require "net/http"
require "json"
require "open-uri"

class PopulateItinerary < ApplicationRecord
  def initialize(itinerary_template = {})
    @itinerary = itinerary_template[:itinerary]
    @itinerary_template = itinerary_template[:template]
    @params = itinerary_template[:params]
  end

  def perform
    populate_itinerary
  end

  private

  def populate_itinerary
    location = "#{@itinerary.latitude},#{@itinerary.longitude}"

    @itinerary_template.each do |event_details|

      search_location = location
      url = generate_url(search_location, event_details)
      alternative_places = fetch_places(url, event_details) # DELETE EVENT ARG
      place = alternative_places["results"].shift
      place_details = populate_place(place)


      event = PopulateEvent.new({
                                  itinerary: @itinerary,
                                  event_details: event_details,
                                  place_details: place_details,
                                  alternative_places: alternative_places
                                }).perform


      raise

    end

  end

  def generate_url(search_location, event_details)
    key = 1234

    URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{search_location}&radius=#{event_details[:radius]}&type=#{event_details[:place_type]}&keyword=#{event_details[:keyword]}&maxprice=#{event_details[:maxprice]}&rankby=prominence&key=#{key}")
  end

  def fetch_places(url, event_details) # DELETE EVENT PARAM
    # https = Net::HTTP.new(url.host, url.port)
    # https.use_ssl = true

    # request = Net::HTTP::Get.new(url)

    # response = https.request(request)

    # response_json = response.read_body
    # JSON.parse(response_json)

    # TEST JSONS
    if event_details[:input_category] == "History"
      filepath = "app/services/test_results/museum_history|culture|immersive.json"
    elsif event_details[:input_category] == "Art & Culture"
      filepath = "app/services/test_results/art_gallery_art|culture|exhibition.json"
    elsif event_details[:input_category] == "Shopping"
      filepath = "app/services/test_results/establishment_ shopping|mall|centre|department|store.json"
    elsif event_details[:input_category] == "dining_dinner"
      filepath = "app/services/test_results/restaurant_japanese|ramen_minprice-_maxprice-.json"
    elsif event_details[:input_category] == "dining_lunch"
      filepath = "app/services/test_results/restaurant_japanese|ramen_minprice-_maxprice-.json"
    elsif event_details[:input_category] == "Drinks"
      filepath = "app/services/test_results/bar_coctail|pub|bar.json"
    elsif event_details[:input_category] == "Activity"
      filepath = "app/services/test_results/tourist_attraction_activity|adventure|experience|interactive.json"
    elsif event_details[:input_category] == "Outdoors"
      filepath = "app/services/test_results/tourist_attraction_park|walk|outdoor|outside|nature.json"
    elsif event_details[:input_category] == "Attraction"
      filepath = "app/services/test_results/tourist_attraction_tourist|attraction.json"
    elsif event_details[:input_category] == "history_art_culture"
      filepath = "app/services/test_results/x_museum_history|culture|immersive|art|culture|exhibition.json"
    elsif event_details[:input_category] == "dining_dinner_drinks"
      filepath = "app/services/test_results/x_restaurant_steak|coctail|wine|beer_maxprice3.json"
    elsif event_details[:input_category] == "dining_lunch_drinks"
      filepath = "app/services/test_results/x_restaurant_steak|coctail|wine|beer_maxprice3.json"
    elsif event_details[:input_category] == "activity_attraction"
      filepath = "app/services/test_results/tourist_attraction_activity|adventure|experience|interactive.json"
    end

    serialized_places = File.read(filepath)
    JSON.parse(serialized_places)
  end

  def populate_place(place)
    {
      name: place["name"], # String
      types: place["types"], # Array
      rating: place["rating"].to_i, # Integer
      user_ratings_total: place["user_ratings_total"].to_i, # Integer
      photo_reference: place["photos"][0]["photo_reference"], # String
      location: "#{place["geometry"]["location"]["lat"]},#{place["geometry"]["location"]["lng"]}", # String
      place_id: place["place_id"], # String
      price_level: place["price_level"] # Integer
    }
  end
end
