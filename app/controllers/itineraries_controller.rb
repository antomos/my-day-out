class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show, :update, :destroy]

  def index
    @events = TestEvent.all
  end

  def show
  end

  def create
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
    params.require(:itinerary).permit(:name, :description)
  end

  def event_params
    params.require(:event).permit(:title, :duration)
  end
end
