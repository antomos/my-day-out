require "uri"
require "net/http"
require "json"
require "open-uri"
require 'pry-byebug'

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
      alternative_places = fetch_places(url, event_details)

      formatted_places = { "results" => format_places(alternative_places["results"]) }

      alternative_places = formatted_places

      # Can I refactor this - check to see if the three conditions that all call the order_filter_places method can be combined into one?
      if event_details[:filter_type].length.positive?
        alternative_places = { "results" => order_filter_places(alternative_places, :types, event_details[:filter_type]) }
      end

      if event_details[:filter_ratings].positive?
        alternative_places = { "results" => order_filter_places(alternative_places, :user_ratings_total, event_details[:filter_ratings]) }
      end

      if event_details[:filter_type].length.zero? && event_details[:filter_ratings].zero?
        alternative_places = { "results" => order_filter_places(alternative_places) }
      end


      # place_details = alternative_places["results"].first#.shift ###############
      place_details = check_duplicates(alternative_places)

      event = PopulateEvent.new({
                                  itinerary: @itinerary,
                                  event_details: event_details,
                                  place_details: place_details,
                                  alternative_places: alternative_places
                                }).perform
    end
  end

  def generate_url(search_location, event_details)
    key = ENV["GOOGLE_API_KEY"]
    ## ORIGINAL
    # URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{search_location}&radius=#{event_details[:radius]}&type=#{event_details[:place_type]}&keyword=#{event_details[:keyword]}&maxprice=#{event_details[:maxprice]}&rankby=prominence&key=#{key}")

    ## EXPERIMENTAL
    URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{search_location}&type=#{event_details[:place_type]}&keyword=#{event_details[:keyword]}&maxprice=#{event_details[:maxprice]}&rankby=distance&key=#{key}")
  end

  def fetch_places(url, event_details)

    ######################## API JSONS ##########################
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    response_json = response.read_body
    JSON.parse(response_json)
    #############################################################

    # ######################### TEST JSONS #########################
    # if event_details[:input_category] == "History"
    #   filepath = "app/services/test_results/museum_history|culture|immersive.json"
    # elsif event_details[:input_category] == "Art & Culture"
    #   filepath = "app/services/test_results/art_gallery_art|culture|exhibition.json"
    # elsif event_details[:input_category] == "Shopping"
    #   filepath = "app/services/test_results/establishment_ shopping|mall|centre|department|store.json"
    # elsif event_details[:input_category] == "dining_dinner"
    #   filepath = "app/services/test_results/restaurant_japanese|ramen_minprice-_maxprice-.json"
    # elsif event_details[:input_category] == "dining_lunch"
    #   filepath = "app/services/test_results/restaurant_japanese|ramen_minprice-_maxprice-.json"
    # elsif event_details[:input_category] == "Drinks"
    #   filepath = "app/services/test_results/bar_coctail|pub|bar.json"
    # elsif event_details[:input_category] == "Activity"
    #   filepath = "app/services/test_results/tourist_attraction_activity|adventure|experience|interactive.json"
    # elsif event_details[:input_category] == "Outdoors"
    #   filepath = "app/services/test_results/tourist_attraction_park|walk|outdoor|outside|nature.json"
    # elsif event_details[:input_category] == "Attraction"
    #   filepath = "app/services/test_results/tourist_attraction_tourist|attraction.json"
    # elsif event_details[:input_category] == "history_art_culture"
    #   filepath = "app/services/test_results/x_museum_history|culture|immersive|art|culture|exhibition.json"
    # elsif event_details[:input_category] == "dining_dinner_drinks"
    #   filepath = "app/services/test_results/x_restaurant_steak|coctail|wine|beer_maxprice3.json"
    # elsif event_details[:input_category] == "dining_lunch_drinks"
    #   filepath = "app/services/test_results/x_restaurant_steak|coctail|wine|beer_maxprice3.json"
    # elsif event_details[:input_category] == "activity_attraction"
    #   filepath = "app/services/test_results/tourist_attraction_activity|adventure|experience|interactive.json"
    # end
    # ##############################################################

    # serialized_places = File.read(filepath)
    # JSON.parse(serialized_places)
  end

  def format_places(alternative_place_results)
    formatted_place_results = []

    alternative_place_results.each do |place|
      formatted_place_results << populate_place(place)
    end

    formatted_place_results
  end

  def populate_place(place)
    if place["photos"]
      photo = place["photos"][0]["photo_reference"] # String
    else
      photo = nil
    end

    {
      name: place["name"], # String
      types: place["types"], # Array
      rating: place["rating"].to_f, # float
      user_ratings_total: place["user_ratings_total"].to_i, # Integer
      photo_reference: photo,
      location: "#{place["geometry"]["location"]["lat"]},#{place["geometry"]["location"]["lng"]}", # String
      place_id: place["place_id"], # String
      price_level: place["price_level"] # Integer
    }
  end

  # method accepts symbol as type argument stored in variable named type - used to either filter by type or user_ratings_total
  def order_filter_places(alternative_places, type = nil, filter_value = nil)
    sorted_places = alternative_places["results"].sort_by { |place| -(place[:rating].to_f * place[:user_ratings_total].to_i * (20 - alternative_places["results"].find_index(place))) }

    # removes places of type that matches filter_value
    if type == :types
      filtered_places = sorted_places.reject { |place| place[type].include?(filter_value) }

    # removes places with user_ratings_total less than filter_value
    elsif type == :user_ratings_total
      filtered_places = sorted_places.reject { |place| place[type] < filter_value }
    else
      filtered_places = sorted_places
    end

    filtered_places
  end

  def check_duplicates(alternative_places)
    # returns first place if this is the first event of the itinerary
    return alternative_places["results"].first unless @itinerary.events.count.positive?
    # reutrns first place if there are no alternative places
    return alternative_places["results"].first unless alternative_places["results"].count > 1

    # need to check if place already exists in itinerary
    @events = Event.where(itinerary_id: @itinerary.id)

    # creates array of place_ids of all events in itinerary
    places = @events.map { |event| event.place.search_place_details_id }

    # iterates through alternative places and returns first place that is not in the places array (i.e. not in the itinerary)
    alternative_places["results"].each do |place|
      next if places.include?(place[:place_id])

      return place
    end
  end
end
