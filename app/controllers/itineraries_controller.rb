require 'pry-byebug'
require 'securerandom'

class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show, :update, :destroy]
  before_action :set_events, only: [:show]

  def index
    # @events = TestEvent.all

  end

  def show
    @itinerary = Itinerary.find(params[:id])
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.user_id = 1
    @params = itinerary_params
    @itinerary.share_token = SecureRandom.hex(16)

    if @itinerary.save!
      itinerary_template = ItineraryTemplate.new(itinerary_params).perform

      PopulateItinerary.new({ itinerary: @itinerary, template: itinerary_template, params: itinerary_params }).perform

      if @itinerary.events.count.positive?
        SetTravelTime.new({ itinerary: @itinerary, index: 0 }).perform
        CheckOpenEvent.new(@itinerary).perform
      end

      redirect_to itinerary_path(@itinerary)
    else
      render root_path, status: :unprocessable_entity
    end
  end

  def update; end

  def destroy; end

  def edit_order
    change_event_orders(params["_json"])
  end

  def save
    @itinerary = Itinerary.find(params[:format])
    @itinerary.saved = true
    @itinerary.save
    redirect_to itinerary_path(@itinerary)
  end

  def back
    @itinerary = Itinerary.find(params[:format])
    @itinerary.saved = false
    @itinerary.save
    redirect_to itinerary_path(@itinerary)
  end

  # def share
  #   @itinerary = Itinerary.find_by(share_token: params[:share_token])
    # if @itinerary.nil?
    #   # Handle invalid share tokens here
    # end
  # end

  private

  def change_event_orders(order)

    @itinerary = Itinerary.find(params[:id])
    # @events = @itinerary.events.order(:order_number)
    @events = @itinerary.events.where(removed: false).order(:order_number)

    # sets index positions for old and new event position
    old_index = order.split(",")[0].to_i #1
    new_index = order.split(",")[1].to_i #3

    return unless old_index != new_index

    # creates array of index for each event
    event_order = @events.length.times.map { |i| i }

    # updates array of event indexes to reflect new order
    event_order.insert(new_index, event_order.delete_at(old_index))

    # assigns correct order_number value to each event
    event_order.length.times { |i| @events[event_order[i]].update(order_number: i + 1) }

    # sets point from where new travel information and times should be generated
    if old_index < new_index
      @index = old_index
    else
      @index = new_index
    end

    # recalculate Itinerary timings with updated travel instructions
    SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform
    CheckOpenEvent.new(@itinerary).perform
  end

  def set_events
    # @events = @itinerary.events.order(:order_number)
    @events = @itinerary.events.where(removed: false).order(:order_number)
  end

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
end
