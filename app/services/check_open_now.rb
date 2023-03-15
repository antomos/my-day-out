class CheckOpenNow < ApplicationRecord
  def initialize(itinerary)
    @itinerary = itinerary
  end

  def perform
    set_open_status
  end

  private

  def set_open_status
    weekday = @itinerary.date.strftime('%A').downcase

    events = @itinerary.events.where(removed: false).order(:order_number)
    events.each do |event|
      event.place.details_opening_hours_periods

      # event.update(open_now: event.place.open_now?)
    end
  end
end
