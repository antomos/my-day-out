require "uri"
require "net/http"
require "json"
require "open-uri"

require 'pry-byebug'

class SetTravelTime < ApplicationRecord
  def initialize(params = {})
    @itinerary = params[:itinerary]
    @index = params[:index]
  end

  def perform
    add_travel_to_schedule
  end

  private

#   ############################## TFL ###########################################
#   ##############################################################################
#   def add_travel_to_schedule

#     # events = @itinerary.events.order(:order_number)
#     events = @itinerary.events.where(removed: false).order(:order_number)
#     events.first.update(delay: 0)

#     return if @index == events.length


#     start_location = "#{@itinerary.latitude},#{@itinerary.longitude}"

#     # TFL API
#     start_date = @itinerary[:date].strftime('%Y%m%d')
#     end_time = @itinerary[:start_time].strftime('%H%M')
#     #######################f

#     events.each_with_index do |event, i|
#       start_time = end_time

#       # Only calls API and sets timings from the first change in the schedule
#       if i >= @index
#         destination_location = event.place.search_geometry_location

#         # TFL
#         url = generate_url(start_location, destination_location, start_time, start_date)
#         directions = fetch_directions(url)
#         #################

#         # TFL
#         hours = start_time.first(2)
#         minutes = start_time.last(2)
#         time = Time.new(1, 1, 1, hours, minutes, 0)
#         #######################

#         # # TFL
#         start_time = time + (directions[:journey_duration].to_i * 60) + (event.delay * 60)
#         #######################


#         start_time = round_time(start_time)
#         event_duration = event.event_duration

#         end_time = start_time + (event_duration * 60)

#         event.update(directions_to_event: directions)
#         event.update(start_time: start_time.strftime('%H:%M'))
#         event.update(end_time: end_time.strftime('%H:%M'))
#       end

#       # TFL
#       end_time = event.end_time.gsub(":", "")
#       #############################

#       start_location = event.place.search_geometry_location
#     end
#   end

#   # TFL API
#   def generate_url(start_location, destination_location, start_time, start_date)
#     key = ENV["TFL_API_KEY"]
#     mode = "tube,overground,dlr"
#     URI("https://api.tfl.gov.uk/Journey/JourneyResults/#{start_location}/to/#{destination_location}?date=#{start_date}&time=#{start_time}&timeIs=departing&journeyPreference=leasttime&mode=#{mode}&walkingSpeed=average&key=#{key}")
#   end
#   ######################

#   # TFL API
#   def fetch_directions(url)
#     https = Net::HTTP.new(url.host, url.port)
#     https.use_ssl = true

#     request = Net::HTTP::Get.new(url)

#     response = https.request(request)
#     response_json = response.read_body
#     search_data = JSON.parse(response_json)

#     if search_data["journeys"]
#       journey_duration = search_data["journeys"].first["duration"]
#       journey_legs = search_data["journeys"].first["legs"].map do |leg|
#         "#{leg["instruction"]["summary"].gsub("9999", "")} (#{leg["duration"]} mins)"
#       end
#     else
#       journey_duration = 15
#       journey_legs = []
#     end

#     {
#       journey_duration: journey_duration,
#       journey_legs: journey_legs
#     }
#   end
#   #######################

#   # TFL
#   def round_time(start_time)
#     min = start_time.min
#     hour = start_time.hour

#     while (min % 5).positive?
#       min += 1
#       if min == 60
#         min = 0
#         hour += 1
#         hour = 0 if hour == 24
#       end
#     end
#     Time.new(1, 1, 1, hour, min, 0)
#   end
# end
# ##############################################################################
# ##############################################################################


############################## GOOGLE ########################################
##############################################################################
  def add_travel_to_schedule

    # events = @itinerary.events.order(:order_number)
    events = @itinerary.events.where(removed: false).order(:order_number)
    events.first.update(delay: 0)

    return if @index == events.length


    start_location = "#{@itinerary.latitude},#{@itinerary.longitude}"

    # Google API
    start_date = @itinerary[:date]
    end_time = @itinerary[:start_time]

    year = start_date.strftime('%Y')
    month = start_date.strftime('%m')
    day = start_date.strftime('%d')
    hour = end_time.strftime('%H')
    min = end_time.strftime('%M')

    end_time = Time.new(year, month, day, hour, min, 0)
    ###################

    events.each_with_index do |event, i|
      start_time = end_time

      event.update(order_number: (i + 1).to_s)

      # Only calls API and sets timings from the first change in the schedule
      if i >= @index
        destination_location = event.place.search_geometry_location

        # Google
        url = generate_url(start_location, destination_location, start_time.to_i)
        directions = fetch_directions(url)
        ######################

        if directions[:journey_duration].include?("h")
          hours = directions[:journey_duration].split[0].to_i
          mins = directions[:journey_duration].split[2].to_i
          journey_duration = ((hours * 60) + mins) * 60
        else
          journey_duration = directions[:journey_duration].to_i * 60
        end

        # Google
        start_time = start_time + journey_duration + (event.delay * 60)
        ########################

        start_time = round_time(start_time)
        event_duration = event.event_duration

        end_time = start_time + (event_duration * 60)

        event.update(directions_to_event: directions)
        event.update(start_time: start_time.strftime('%H:%M'))
        event.update(end_time: end_time.strftime('%H:%M'))
      end

      end_time = event.end_time.gsub(":", "")

      year = start_date.strftime('%Y')
      month = start_date.strftime('%m')
      day = start_date.strftime('%d')
      hour = end_time.first(2)
      min = end_time.last(2)

      end_time = Time.new(year, month, day, hour, min, 0)

      start_location = event.place.search_geometry_location
    end
  end

  # # Google API
  def generate_url(start_location, destination_location, start_time)
    key = ENV["GOOGLE_API_KEY"]

    # url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{start_location}&destination=#{destination_location}&departure_time=#{start_time}&mode=transit&transit_mode=subway|train|tram|rail&key=#{key}"

    # binding.pry
    URI("https://maps.googleapis.com/maps/api/directions/json?origin=#{start_location}&destination=#{destination_location}&departure_time=#{start_time}&mode=transit&transit_mode=subway|train|tram|rail|bus&key=#{key}")
  end
  ############################

  # # Google API
  def fetch_directions(url)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    response_json = response.read_body
    search_data = JSON.parse(response_json)

    if search_data["routes"].first
      if search_data["routes"].first["legs"].first
        journey_duration = search_data["routes"].first["legs"].first["duration"]["text"].gsub("hours", "h").gsub("mins", "m")

        journey_legs = []
        search_data["routes"].first["legs"].first["steps"].each do |step|

          journey_legs << "#{step["html_instructions"]} (#{step["duration"]["text"]})"
          if step["transit_details"]
            line = step["transit_details"]["line"]["name"]
            arrival_stop = step["transit_details"]["arrival_stop"]["name"]
            departure_stop = step["transit_details"]["departure_stop"]["name"]
            stops = step["transit_details"]["num_stops"]
            journey_legs << "#{line} (#{stops} stops): #{departure_stop} to #{arrival_stop}"
          end
        end
      end
    else
      journey_duration = "15 m"
      journey_legs = []
    end

    directions = {
      journey_duration: journey_duration,
      journey_legs: journey_legs
    }
  end
  ###########################

  # Google
  def round_time(start_time)

    year = start_time.strftime('%Y').to_i
    month = start_time.strftime('%m').to_i
    day = start_time.strftime('%d').to_i
    hour = start_time.strftime('%H').to_i
    min = start_time.strftime('%M').to_i

    while (min % 5).positive?
      min += 1
      if min == 60
        min = 0
        hour += 1
        hour = 0 if hour == 24
      end
    end
    Time.new(year, month, day, hour, min, 0)
  end
end
##############################################################################
##############################################################################
