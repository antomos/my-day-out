class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show, :update, :destroy]

  def index
    @events = TestEvent.all
  end

  def show
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    details_wheelchair_accessible_entrance = params[:itinerary][:details_wheelchair_accessible_entrance]
    raise
  end

  def update
  end

  def destroy
  end

  private

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end

  def itinerary_params
    params.require(:itinerary).permit(:start_address, :start_time, :interests, :details_wheelchair_accessible_entrance)
  end

  def event_params
    params.require(:event).permit(:title, :duration)
  end
end
