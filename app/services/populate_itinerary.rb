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
    location = @params["start_address"]

    @itinerary_template.each do |event|
      search_location = location

      url = generate_url(search_location, event)
      places = fetch_places(url, event) # DELETE EVENT ARG
      raise
    end
  end

  def generate_url(search_location, event)
    key = 1234
    # "AIzaSyD_LhDBKQlxOLO34kgMh0cuT8YXR63ndFg"
    URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{search_location}&radius=#{event[:radius]}&type=#{event[:place_type]}&keyword=#{event[:keyword]}&maxprice=#{event[:maxprice]}&rankby=prominence&key=#{key}")
  end

  def fetch_places(url, event) # DELETE EVENT PARAM
    # https = Net::HTTP.new(url.host, url.port)
    # https.use_ssl = true

    # request = Net::HTTP::Get.new(url)

    # response = https.request(request)

    # response_json = response.read_body
    # JSON.parse(response_json)

    # TEST JSONS
    if event[:input_category] == "History"
      filepath = "app/services/test_results/museum_history|culture|immersive.json"
    elsif event[:input_category] == "Art & Culture"
      filepath = "app/services/test_results/art_gallery_art|culture|exhibition.json"
    elsif event[:input_category] == "Shopping"
      filepath = "app/services/test_results/establishment_ shopping|mall|centre|department|store.json"
    elsif event[:input_category] == "dining_dinner"
      filepath = "app/services/test_results/restaurant_japanese|ramen_minprice-_maxprice-.json"
    elsif event[:input_category] == "dining_lunch"
      filepath = "app/services/test_results/restaurant_japanese|ramen_minprice-_maxprice-.json"
    elsif event[:input_category] == "Drinks"
      filepath = "app/services/test_results/bar_coctail|pub|bar.json"
    elsif event[:input_category] == "Activity"
      filepath = "app/services/test_results/tourist_attraction_activity|adventure|experience|interactive.json"
    elsif event[:input_category] == "Outdoors"
      filepath = "app/services/test_results/tourist_attraction_park|walk|outdoor|outside|nature.json"
    elsif event[:input_category] == "Attraction"
      filepath = "app/services/test_results/tourist_attraction_tourist|attraction.json"
    elsif event[:input_category] == "history_art_culture"
      filepath = "app/services/test_results/x_museum_history|culture|immersive|art|culture|exhibition.json"
    elsif event[:input_category] == "dining_dinner_drinks"
      filepath = "app/services/test_results/x_restaurant_steak|coctail|wine|beer_maxprice3.json"
    elsif event[:input_category] == "dining_lunch_drinks"
      filepath = "app/services/test_results/x_restaurant_steak|coctail|wine|beer_maxprice3.json"
    elsif event[:input_category] == "activity_attraction"
      filepath = "app/services/test_results/tourist_attraction_activity|adventure|experience|interactive.json"
    end

    serialized_places = File.read(filepath)
    JSON.parse(serialized_places)

  end
end
