class PagesController < ApplicationController
  def home
    @itinerary = Itinerary.new
  end

  def shared
    @itinerary = Itinerary.find_by(share_token: params[:share_token])
    @events = @itinerary.events.where(removed: false).order(:order_number)

    # if @itinerary.nil?
      # Handle invalid share tokens here
    # end
  end
end
