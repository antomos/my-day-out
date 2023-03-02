class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy]

  def create
    @event = Event.new(event_params)
    @event.save
    redirect_to @event
  end

  def update
    @event.update(event_params)
    redirect_to @event
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:itinerary_id, :place_id, :start_time, :end_time)
  end
end
