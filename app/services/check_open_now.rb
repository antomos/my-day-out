class CheckOpenNow < ApplicationRecord
  def initialize(itinerary)
    @itinerary = itinerary
    raise
  end

  def perform
    set_open_status
  end

  private

  def set_open_status
    events = @itinerary.events.where(removed: false).order(:order_number)

    # events.each do |event|
    #   event.update(open_now: event.place.open_now?)
    # end
  end
end
