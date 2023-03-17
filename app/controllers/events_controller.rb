require "pry-byebug"
class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy, :remove]

  def create
  end

  def edit
    @event = Event.find(params[:id])
    @itinerary = Itinerary.find(@event.itinerary_id)


  end

  def update
    place_name = event_params["place"]
    new_start = event_params["start_time"]
    new_end = event_params["end_time"]

    # raise

    upate_event_place(place_name) if place_name != "" && place_name != @event.place.name
    update_event_time(new_start, new_end) if new_start != @event.start_time || new_end != @event.end_time

    redirect_to itinerary_path(@event.itinerary_id) # (fallback_location: itinerary_path, _csrf_token: form_authenticity_token)
  end

  def destroy
  end

  def remove
    @event.update(removed: true)

    # sets point from where new travel information and times should be generated
    @index = @event[:order_number].to_i - 1

    @itinerary = Itinerary.find(@event.itinerary_id)

    @events = @itinerary.events.where(removed: false).order(:order_number)

    @events.each_with_index do |event, index|
      event.update(order_number: index + 1)
    end

    SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform
    CheckOpenEvent.new(@itinerary).perform

    redirect_to itinerary_path(@event.itinerary_id)
  end

  private

  def upate_event_place(place_name)
    @event.alternative_places["results"].each do |alternative|
      if alternative["name"] == place_name
        @search_place_details = alternative
        break
      end
    end

    #convert string keys to symbols
    key_to_symbols = @search_place_details
    @search_place_details = {}

    key_to_symbols.each do |key, value|
      @search_place_details[key.to_sym] = value
    end

    # CHANGE THE EXISTING PLACE CHECK TO THE ONE LINE FIND_BY_OR_CREATE?
    if Place.find_by(search_place_details_id: @search_place_details[:place_id])
      new_place = Place.find_by(search_place_details_id: @search_place_details[:place_id])
    else
      place_details = RequestPlaceDetail.new(@search_place_details).perform

      new_place = PopulatePlace.new({
                                # event_details: @event_details,
                                  search_place_details: @search_place_details,
                                  place_details: place_details
                                }).perform
    end

    @event.update(place: new_place)

    # sets point from where new travel information and times should be generated
    @index = @event[:order_number].to_i - 1

    @itinerary = Itinerary.find(@event.itinerary_id)
    SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform
    CheckOpenEvent.new(@itinerary).perform
  end

  def update_event_time(new_start, new_end)
    old_start = convert_time(@event.start_time)
    new_start = convert_time(new_start)
    old_end = convert_time(@event.end_time)
    new_end = convert_time(new_end)

    @event.update(start_time: new_start.strftime('%H:%M'))
    @event.update(end_time: new_end.strftime('%H:%M'))

    # raise

    if new_start < old_start
      prior_event_order_number = @event.order_number.to_i - 1
      prior_event = Event.find_by(itinerary_id: @event.itinerary_id, order_number: prior_event_order_number.to_s)
      # raise

      prior_event_end_time = round_time(new_start - (@event.directions_to_event["journey_duration"].to_i) * 60)
      prior_event_end_time = prior_event_end_time.strftime('%H:%M')
      prior_event.update(end_time: prior_event_end_time)
    end

    # raise
  end

  def convert_time(time)
    hours = time.first(2)
    minutes = time.last(2)
    Time.new(1, 1, 1, hours, minutes, 0)
  end

  def round_time(time)
    min = time.min
    hour = time.hour

    while (min % 5).positive?
      min -= 1 # -???
      if min == 60
        min = 0
        hour += 1
        hour = 0 if hour == 24
      end
    end
    Time.new(1, 1, 1, hour, min, 0)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:place, :start_time, :end_time)
  end
end
