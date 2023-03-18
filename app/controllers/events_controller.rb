require "pry-byebug"
class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy, :remove]

  def create
    # place = event_params[:place]
    place = "Heliot Steak House, Hippodrome Casino, Cranbourn Street, Leicester Square, London, UK"
    itinerary_id = params[:itinerary_id]

    event = CreateUserEvent.new({ new_event: Event.new, place: place, itinerary_id: itinerary_id }).perform

    if event.save!
      @itinerary = Itinerary.find(itinerary_id)
      SetTravelTime.new({ itinerary: @itinerary, index: 0 }).perform
      CheckOpenEvent.new(@itinerary).perform

      redirect_to itinerary_path(@itinerary, confirmed: false)
    else
      render itinerary_path(@itinerary), status: :unprocessable_entity
    end

  end

  def edit
    @event = Event.find(params[:id])
    @itinerary = Itinerary.find(@event.itinerary_id)


  end

  def update
    place_name = event_params["place"]
    new_start = event_params["start_time"]
    new_end = event_params["end_time"]

    # raise

    upate_event_place(place_name) if place_name != "" && place_name != @event.place.name
    update_event_time(new_start, new_end) if new_start != @event.start_time || new_end != @event.end_time

    redirect_to itinerary_path(@event.itinerary_id) # (fallback_location: itinerary_path, _csrf_token: form_authenticity_token)
  end

  def destroy
  end

  def remove
    @event.update(removed: true)

    # sets point from where new travel information and times should be generated
    @index = @event[:order_number].to_i - 1

    @itinerary = Itinerary.find(@event.itinerary_id)

    @events = @itinerary.events.where(removed: false).order(:order_number)

    @events.each_with_index do |event, index|
      event.update(order_number: index + 1)
    end

    SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform
    CheckOpenEvent.new(@itinerary).perform

    redirect_to itinerary_path(@event.itinerary_id)
  end

  private

  def upate_event_place(place_name)
    @event.alternative_places["results"].each do |alternative|
      if alternative["name"] == place_name
        @search_place_details = alternative
        break
      end
    end

    #convert string keys to symbols
    key_to_symbols = @search_place_details
    @search_place_details = {}

    key_to_symbols.each do |key, value|
      @search_place_details[key.to_sym] = value
    end

    # CHANGE THE EXISTING PLACE CHECK TO THE ONE LINE FIND_BY_OR_CREATE?
    if Place.find_by(search_place_details_id: @search_place_details[:place_id])
      new_place = Place.find_by(search_place_details_id: @search_place_details[:place_id])
    else
      place_details = RequestPlaceDetail.new(@search_place_details).perform

      new_place = PopulatePlace.new({
                                # event_details: @event_details,
                                  search_place_details: @search_place_details,
                                  place_details: place_details
                                }).perform
    end

    @event.update(place: new_place)

    # sets point from where new travel information and times should be generated
    @index = @event[:order_number].to_i - 1

    @itinerary = Itinerary.find(@event.itinerary_id)
    SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform
    CheckOpenEvent.new(@itinerary).perform
  end

  def update_event_time(new_start, new_end)
    old_start = convert_time(@event.start_time)
    new_start = convert_time(new_start)
    old_end = convert_time(@event.end_time)
    new_end = convert_time(new_end)

    new_end = new_start + (5 * 60) if new_end <= new_start

    @event.update(end_time: new_end.strftime('%H:%M')) if new_end != old_end

    @itinerary = Itinerary.find(@event.itinerary_id)

    prior_event_order_number = @event.order_number.to_i - 1
    prior_event = Event.find_by(itinerary_id: @event.itinerary_id, order_number: prior_event_order_number.to_s)


    if new_start != old_start
      @event.update(start_time: new_start.strftime('%H:%M'))

      if @event.order_number.to_i == 1
        new_itinerary_start_time = round_time(new_start - (@event.directions_to_event["journey_duration"].to_i * 60))
        @itinerary.update(start_time: new_itinerary_start_time)

      elsif new_start < old_start
        prior_event_end_time = round_time(new_start - (@event.directions_to_event["journey_duration"].to_i * 60))
        prior_event.update(end_time: prior_event_end_time.strftime('%H:%M'))

      end

      if @event.order_number.to_i > 1
        if new_start - (@event.directions_to_event["journey_duration"].to_i * 60) > convert_time(prior_event.end_time)
          delay = (new_start - (@event.directions_to_event["journey_duration"].to_i * 60)) - convert_time(prior_event.end_time)
          @event.update(delay: delay / 60)
        else
          @event.update(delay: 0)
        end
      end
    end

    @index = @event[:order_number].to_i - 1
    new_event_duration = (new_end - new_start) / 60
    @event.update(event_duration: new_event_duration)

    SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform


    # if new_start >= new_end
    #   @event.update(end_time: (new_start + (5 * 60)).strftime('%H:%M'))
    #   @index = @event[:order_number].to_i
    # else
    #   @index = @event[:order_number].to_i - 1
    # end

    # if new_start < old_start && @event.order_number != 1.to_s
    #   prior_event_order_number = @event.order_number.to_i - 1
    #   prior_event = Event.find_by(itinerary_id: @event.itinerary_id, order_number: prior_event_order_number.to_s)

    #   prior_event_end_time = round_time(new_start - (@event.directions_to_event["journey_duration"].to_i) * 60)

    #   prior_event.update(end_time: prior_event_end_time.strftime('%H:%M'))

    # elsif new_start < old_start && @event.order_number == 1.to_s
    #   new_itinerary_start_time = round_time(new_start - (@event.directions_to_event["journey_duration"].to_i) * 60)
    #   @itinerary.update(start_time: new_itinerary_start_time)

    # elsif new_start > old_start && @event.order_number == 1.to_s
    #   @itinerary.update(start_time: new_start)
    #   @index = @event[:order_number].to_i
    # end

    # new_event_duration = (new_end - new_start) / 60
    # @event.update(event_duration: new_event_duration)

    # SetTravelTime.new({ itinerary: @itinerary, index: @index }).perform

    # raise
  end

  def convert_time(time)
    hours = time.first(2)
    minutes = time.last(2)
    Time.new(1, 1, 1, hours, minutes, 0)
  end

  def round_time(time)
    min = time.min
    hour = time.hour

    while (min % 5).positive?
      min -= 1 # -???
      if min == 60
        min = 0
        hour += 1
        hour = 0 if hour == 24
      end
    end
    Time.new(1, 1, 1, hour, min, 0)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:place, :start_time, :end_time, :itinerary_id)
  end
end
