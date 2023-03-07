require "uri"
require "net/http"
require "json"
require "open-uri"

class PopulateEvent < ApplicationRecord
  def initialize(event_template = {})
    @itinerary = event_template[:itinerary]
    @event_details = event_template[:event_details]
    @search_place_details = event_template[:place_details]
    @alternative_places = event_template[:alternative_places]
  end

  def perform
    new_event
  end

  private

  def new_event
    event = Event.new
    event.itinerary = @itinerary
    event.start_time = @event_details[:event_start_time]
    event.end_time = @event_details[:event_end_time]
    event.order_number = @event_details[:order_number]
    event.alternative_places = @alternative_places

    #get event details
    url = generate_url
    place_details = fetch_place_details(url)

    place = PopulatePlace.new({
                                event_details: @event_details,
                                search_place_details: @search_place_details,
                                place_details: place_details
                              }).perform

    event.directions_to_event = "NO DIRECTIONS YET"
    event.place = place

    event.save!

    event
  end

  def generate_url
    key = 1234

    URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{@search_place_details[:place_id]}&key=#{key}")
  end

  def fetch_place_details(url)

  filepath = "app/services/test_results/place_details_test.json"


  serialized_places = File.read(filepath)
  JSON.parse(serialized_places)


    # https = Net::HTTP.new(url.host, url.port)
    # https.use_ssl = true

    # request = Net::HTTP::Get.new(url)

    # response = https.request(request)

    # response_json = response.read_body
    # JSON.parse(response_json)
  end

end
