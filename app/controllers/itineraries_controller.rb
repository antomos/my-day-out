class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show, :update, :destroy]

  def index
  end

  def show
  end

  def create
    @itinerary = Itinerary.new(params[:itinerary])
    if @itinerary.save
      flash[:notice] = "Successfully created itinerary."
      redirect_to @itinerary
    else
      render :action => 'new'
    end
  end

  def update
    if @itinerary.update_attributes(params[:itinerary])
      flash[:notice] = "Successfully updated itinerary."
      redirect_to @itinerary
    else
      render :action => 'edit'
    end
  end

  def destroy
    @itinerary.destroy
    flash[:notice] = "Successfully destroyed itinerary."
    redirect_to itineraries_url
  end

  private

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end

  def itinerary_params
    params.require(:itinerary).permit(:name, :description)
  end
end
