class CreateUserEvent < ApplicationRecord
  def initialize(event_details = {})
    @new_event = event_details[:new_event]
    @itinerary_id = event_details[:itinerary_id]
    @place = event_details[:place]
  end

  def perform
    create_event
  end

  private

  def create_event
    order_number = Event.where(itinerary_id: @itinerary_id, removed: false).order(:order_number).last.order_number.to_i + 1

    @new_event.itinerary_id = @itinerary_id
    @new_event.start_time = "00:00"
    @new_event.end_time = "00:00"
    @new_event.order_number = order_number.to_s
    @new_event.event_duration = 60

    if Place.find_by(name: @place.split(",").first)
      place = Place.find_by(name: @place.split(",").first)
    else
      place_details = fetch_place_details
      create_place(place_details)
    end

    @new_event.place = place
    @new_event
  end

  def fetch_place_details

    # ISSUE - PLACE SEARCH ONLY RETURNS THE GOD DAMN PLACE ID! DOUBLE API REQUESTS!!!
    # key = ENV["GOOGLE_API_KEY"]
    # URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{@place_details[:place_id]}&key=#{key}")
    # "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{Place}&inputtype=textquery&key=#{key}"


    ######################### API JSONS ##########################
    # https = Net::HTTP.new(url.host, url.port)
    # https.use_ssl = true
    # request = Net::HTTP::Get.new(url)
    # response = https.request(request)
    # response_json = response.read_body
    # JSON.parse(response_json)
    ##############################################################



  end

  def create_place

  end
end
