require "uri"
require "net/http"
require "json"
require "open-uri"

class SetTravelTime < ApplicationRecord
  def initialize(params = {})
    @itinerary = params[:itinerary]
    @index = params[:index]
  end

  def perform
    add_travel_to_schedule
  end

  private

  def add_travel_to_schedule
    start_location = "#{@itinerary.latitude},#{@itinerary.longitude}"

    start_date = @itinerary[:date].strftime('%Y%m%d')
    end_time = @itinerary[:start_time].strftime('%H%M')

    events = @itinerary.events.order(:order_number)

    # events = events.slice(@index, array.length) if @index

    events.each_with_index do |event, i|
      start_time = end_time

      # Only calls API and sets timings from the first change in the schedule
      if i >= @index
        destination_location = event.place.search_geometry_location

        url = generate_url(start_location, destination_location, start_time, start_date)
        directions = fetch_directions(url)

        hours = start_time.first(2)
        minutes = start_time.last(2)
        time = Time.new(1, 1, 1, hours, minutes, 0)
        start_time = time + (directions[:journey_duration].to_i * 60)

        start_time = round_time(start_time)
        event_duration = event.event_duration

        end_time = start_time + (event_duration * 60)

        event.update(directions_to_event: directions)
        event.update(start_time: start_time.strftime('%H:%M'))
        event.update(end_time: end_time.strftime('%H:%M'))
      end

      # end_time = end_time.strftime('%H%M')
      # start_location = destination_location
      end_time = event.end_time.gsub(":", "")
      start_location = event.place.search_geometry_location
    end
  end

  def generate_url(start_location, destination_location, start_time, start_date)
    mode = "tube,overground,dlr"
    URI("https://api.tfl.gov.uk/Journey/JourneyResults/#{start_location}/to/#{destination_location}?date=#{start_date}&time=#{start_time}&timeIs=departing&journeyPreference=leasttime&mode=#{mode}&walkingSpeed=average")
  end

  def fetch_directions(url)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    response_json = response.read_body
    search_data = JSON.parse(response_json)

    if search_data["journeys"]
      journey_duration = search_data["journeys"].first["duration"]
      journey_legs = search_data["journeys"].first["legs"].map do |leg|
        "#{leg["instruction"]["summary"].gsub("9999", "")} (#{leg["duration"]} mins)"
      end
    else
      journey_duration = 15
      journey_legs = []
    end

    {
      journey_duration: journey_duration,
      journey_legs: journey_legs
    }
  end

  def round_time(start_time)
    min = start_time.min
    hour = start_time.hour

    while (min % 5).positive?
      min += 1
      if min == 60
        min = 0
        hour += 1
        hour = 0 if hour == 24
      end
    end
    Time.new(1, 1, 1, hour, min, 0)
  end
end
