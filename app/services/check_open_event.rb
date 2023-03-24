require 'json'
require 'pry-byebug'

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

      if event.place.details_opening_hours_periods # places with no opening hours details crashes

        opening_hours_hash = event.place.details_opening_hours_periods
        # opening_hours_hash = eval(opening_hours_string)

        # binding.pry

        if opening_hours_hash
          opening_string = opening_hours_hash["periods"][week.index(weekday)]["open"]["time"] if opening_hours_hash["periods"][week.index(weekday)]
          closing_string = opening_hours_hash["periods"][week.index(weekday)]["close"]["time"] if opening_hours_hash["periods"][week.index(weekday)]
          # opening_time = Time.parse(opening_string)
          # closing_time = Time.parse(closing_string)

          opening_time = Time.strptime(opening_string, "%H%M") if opening_string
          closing_time = Time.strptime(closing_string, "%H%M") if closing_string

          if closing_time && opening_time
            closing_time += (60*60*24) if closing_time < opening_time
          end

          # make sure event start & end time are both time objects for comparison
          # for some reason, event.start_time and event.end_time call different values to that is stored in event...
          start_time = Time.strptime(event.start_time.gsub(":", ""), "%H%M")
          end_time = Time.strptime(event.end_time.gsub(":", ""), "%H%M")
        end

        if opening_time && closing_time
          if start_time >= opening_time && end_time <= closing_time
            event.update(open_now: true)
          else
            event.update(open_now: false)
          end
        else
          event.update(open_now: false)
        end
      end
    end
  end
end
