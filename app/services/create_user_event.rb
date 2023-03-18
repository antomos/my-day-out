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

    if Place.find_by(name: @place)

    @new_event.place_id = 41

    @new_event
  end
end
