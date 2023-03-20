require "pry-byebug"
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

    @new_event.itinerary_id = @itinerary_id.to_i
    @new_event.start_time = "00:00"
    @new_event.end_time = "00:00"
    @new_event.order_number = order_number.to_s
    @new_event.event_duration = 60
    @new_event.directions_to_event = "NO DIRECTIONS YET"
    @new_event.removed = false

    if Place.find_by(search_place_details_id: @place)
      place = Place.find_by(search_place_details_id: @place)
    else
      @search_place_details = { place_id: @place }
      place_details = RequestPlaceDetail.new(@search_place_details).perform

      # Constructs hash for use in populate_place
      @search_place_details[:name] = place_details["result"]["name"]
      if place_details["result"]["photos"]
        @search_place_details[:photo_reference] = place_details["result"]["photos"].first["photo_reference"] if place_details["result"]["photos"].first
      end

      place = PopulatePlace.new({
        search_place_details: @search_place_details,
        place_details: place_details
      }).perform
    end

    @new_event.place = place
    @new_event
  end

end
