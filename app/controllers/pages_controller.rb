class PagesController < ApplicationController
  def home
    @itinerary = Itinerary.new
  end
end
