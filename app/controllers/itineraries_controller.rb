class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show, :update, :destroy]

  def index
     @events = TestEvent.all
    @itineraries = Itinerary.all
  end

  def show
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.user = current_user
    @params = itinerary_params

    if @itinerary.save!
      itinerary_template = ItineraryTemplate.new(itinerary_params).perform

      PopulateItinerary.new({ itinerary: @itinerary, template: itinerary_template, params: itinerary_params }).perform
      redirect_to itinerary_path(@itinerary)
    else
      render root_path, status: :unprocessable_entity
    end
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
    params.require(:itinerary).permit(
      :start_address,
      :date,
      :start_time,
      :end_time,
      :budget,
      :dining_requirements,
      :details_wheelchair_accessible_entrance,
      interests: []
    )
  end

  def event_params
    params.require(:event).permit(:title, :durasion)
  end
end
