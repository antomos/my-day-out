class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy]

  def create
  end

  def update
    # raise
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
    # REFRESH PAGE AUTOMATICALLY
  end

  def destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:place)
  end
end
