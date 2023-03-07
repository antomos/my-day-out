require "uri"
require "net/http"
require "json"
require "open-uri"

class PopulateEvent < ApplicationRecord
  def initialize(event_template = {})
    @itinerary = event_template[:itinerary]
    @event_details = event_template[:event_details]
    @place_details = event_template[:place_details]
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

    event.directions_to_event = "NO DIRECTIONS YET"
    # event.place =
    event
  end

  def generate_url
    key = 1234

    URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{@place_details[:place_id]}&key=#{key}")
  end

  def fetch_place_details(url)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)

    response_json = response.read_body
    JSON.parse(response_json)
  end

end
