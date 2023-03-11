class TestEventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy]

  def create
  end

  def update
    @event = TestEvent.find(params[:id])
    @event.update!(event_params)
    respond_to do |format|
      format.html { redirect_to events_path }
      format.text { render partial: "itineraries/card", locals: {event: @event}, formats: [:html] }
    end
  end

  def destroy
  end

  private

  def set_event
    @event = TestEvent.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:itinerary_id, :place_id, :start_time, :end_time)
  end

  def event_params
    params.require(:test_event).permit(:title, :duration)
  end
end
