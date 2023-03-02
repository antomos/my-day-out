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
end
