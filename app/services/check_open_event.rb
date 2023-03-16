require 'json'

class CheckOpenEvent < ApplicationRecord
  def initialize(itinerary)
    @itinerary = itinerary
  end

  def perform
    set_open_status
  end

  private

  def set_open_status
    weekday = @itinerary.date.strftime('%A')
    week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    events = @itinerary.events.where(removed: false).order(:order_number)
    events.each do |event|
      opening_hours_string = event.place.details_opening_hours_periods
      opening_hours_hash = JSON.parse(opening_hours_string.gsub('=>', ':'))

      opening_string = opening_hours_hash["periods"][week.index(weekday)]["open"]["time"]
      closing_string = opening_hours_hash["periods"][week.index(weekday)]["close"]["time"]
      # opening_time = Time.parse(opening_string)
      # closing_time = Time.parse(closing_string)
      opening_time = Time.strptime(opening_string, "%H%M")
      closing_time = Time.strptime(closing_string, "%H%M")


      if event.start_time > opening_time && event.end_time < closing_time
        event.update(open_now: true)
      else
        event.update(open_now: false)
      end
    end
  end
end
