class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy]

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:itinerary_id, :place_id, :start_time, :end_time)
  end
end
