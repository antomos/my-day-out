require "pry-byebug"
class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy, :remove]

  def create
  end

  def update

    params = event_params
    place_name = params["place"]

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

    # Making 2 new places??
    # binding.pry

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

    # DOUBE ENTRY TO DB MADE BEFORE THIS LINE!!!
    # ISSUE WHEN SAVING - CHANGE THE EXISTING PLACE CHECK TO THE ONE LINE FIND_BY_OR_CREATE??

    @event.update(place: new_place)

    # sets point from where new travel information and times should be generated
    @index = @event[:order_number].to_i - 1

    @itinerary = Itinerary.find(@event.itinerary_id)
    SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform

   //redirect_to itinerary_path(@event.itinerary_id) # (fallback_location: itinerary_path, _csrf_token: form_authenticity_token)
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

    redirect_to itinerary_path(@event.itinerary_id)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:place)
  end
end
