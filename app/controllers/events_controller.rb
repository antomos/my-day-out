require 'pry-byebug'

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

    # binding.pry

    place_details = RequestPlaceDetail.new(@search_place_details).perform

    # binding.pry
    place = PopulatePlace.new({
                              # event_details: @event_details,
                                search_place_details: @search_place_details,
                                place_details: place_details
                              }).perform

    if place.save!
      @event.update(place: place)
      #REFRESH PAGE AUTOMATICALLY
    else
      raise
    end
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
