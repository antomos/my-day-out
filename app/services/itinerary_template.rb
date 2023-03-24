class ItineraryTemplate < ApplicationRecord
  def initialize(params)
    # puts "TEST"
    @params = params
  end

  def perform
    # raise
    create_template
  end

  private
  ## ORIGINAL
  # INTEREST_VALUES = {
  #   "History": {time: 75, type: "museum", keyword: "history|culture|immersive", radius: 2000, filter_type: "art_gallery", filter_ratings: 0},
  #   "Art & Culture": {time: 60, type: "art_gallery", keyword: "art|culture|exhibition", radius: 1500, filter_type: "", filter_ratings: 50},
  #   "Shopping": {time: 60, type: "establishment", keyword: "shopping|mall|centre|department|store", radius: 2000, filter_type: "", filter_ratings: 100}, # switch type to shopping_mall?
  #   "dining_dinner": {time: 90, type: "restaurant", keyword: "", radius: 500, filter_type: "", filter_ratings: 0},
  #   "dining_lunch": {time: 60, type: "restaurant", keyword: "", radius: 500, filter_type: "", filter_ratings: 0},
  #   "Drinks": {time: 45, type: "bar", keyword: "cocktail|pub|bar", radius: 500, filter_type: "", filter_ratings: 0},
  #   "Activity": {time: 90, type: "tourist_attraction", keyword: "activity|adventure|experience|interactive", radius: 2500, filter_type: "", filter_ratings: 0},
  #   "Outdoors": {time: 45, type: "tourist_attraction", keyword: "park|walk|outdoor|outside|nature", radius: 2000, filter_type: "", filter_ratings: 0},
  #   "Attraction": {time: 60, type: "tourist_attraction", keyword: "tourist|attraction", radius: 2500, filter_type: "museum", filter_ratings: 100},
  #   "history_art_culture": {time: 75, type: "museum", keyword: "history|culture|immersive|art|culture|exhibition", radius: 2000, filter_type: "", filter_ratings: 50},
  #   "dining_dinner_drinks": {time: 90, type: "restaurant", keyword: "cocktail|wine|beer", radius: 500, filter_type: "", filter_ratings: 0},
  #   "dining_lunch_drinks": {time: 75, type: "restaurant", keyword: "cocktail|wine|beer", radius: 500, filter_type: "", filter_ratings: 0},
  #   "activity_attraction": {time: 75, type: "tourist_attraction", keyword: "activity|adventure|experience|interactive", radius: 2500, filter_type: "", filter_ratings: 0}
  # }

  ## EXPERIMENTAL
  INTEREST_VALUES = {
    "History": {time: 75, type: "museum", keyword: "history|culture|immersive", radius: 1500, filter_type: "art_gallery", filter_ratings: 0},
    "Art & Culture": {time: 60, type: "art_gallery", keyword: "", radius: 1500, filter_type: "", filter_ratings: 3},
    "Shopping": {time: 60, type: "shopping_mall", keyword: "shopping|mall|centre|department|store", radius: 2000, filter_type: "", filter_ratings: 100}, # switch type to shopping_mall?
    "dining_dinner": {time: 90, type: "restaurant", keyword: "", radius: 500, filter_type: "", filter_ratings: 0},
    "dining_lunch": {time: 60, type: "restaurant", keyword: "", radius: 500, filter_type: "", filter_ratings: 0},
    "Drinks": {time: 45, type: "bar", keyword: "cocktail|pub|bar", radius: 500, filter_type: "", filter_ratings: 0},
    "Activity": {time: 90, type: "tourist_attraction", keyword: "activity|adventure|experience|interactive", radius: 1500, filter_type: "", filter_ratings: 0},
    "Outdoors": {time: 45, type: "tourist_attraction", keyword: "park|walk|outdoor|outside|nature", radius: 2000, filter_type: "", filter_ratings: 0},
    "Attraction": {time: 60, type: "tourist_attraction", keyword: "tourist|attraction", radius: 1500, filter_type: "museum", filter_ratings: 100},
    "history_art_culture": {time: 75, type: "museum", keyword: "history|culture|immersive|art|culture|exhibition", radius: 1500, filter_type: "", filter_ratings: 50},
    "dining_dinner_drinks": {time: 90, type: "restaurant", keyword: "cocktail|wine|beer", radius: 500, filter_type: "", filter_ratings: 0},
    "dining_lunch_drinks": {time: 75, type: "restaurant", keyword: "cocktail|wine|beer", radius: 500, filter_type: "", filter_ratings: 0},
    "activity_attraction": {time: 75, type: "tourist_attraction", keyword: "activity|adventure|experience|interactive", radius: 1500, filter_type: "", filter_ratings: 0}
  }

  TRAVEL_TIME = 15
  DINING_TYPE_TIME = Time.new(1, 1, 1, 17, 0, 0)
  LUNCH_CUTOFF = Time.new(1, 1, 1, 11, 45, 0)
  DINNER_CUTOFF = Time.new(1, 1, 1, 18, 30, 0)
  DRINKING_CUTOFF = Time.new(1, 1, 1, 16, 0, 0)

  DINING_DRINKS = ["dining_lunch", "dining_lunch_drinks", "dining_dinner", "dining_dinner_drinks"]

  def create_template

    # Test values from form
    # params = {
    #   interests: [
    #     "history",
    #     "art_culture",
    #     "dining",
    #     "drinks",
    #     # "activity",
    #     "shopping",
    #     # "outdoors",
    #     "attraction"
    #   ],
    #   start_time: Time.new(Time.now.year, Time.now.month, Time.now.day, 13, 0, 0),
    #   end_time: Time.new(Time.now.year, Time.now.month, Time.now.day, 19, 0, 0),
    #   dining_requirements: "italian",
    #   dining_budget: [0, 3],
    #   location: "51.512990,-0.131592"
    # }

    # {"start_address"=>"asdsad", "date"=>"04/12/2023", "start_time(1i)"=>"2023", "start_time(2i)"=>"3", "start_time(3i)"=>"6", "start_time(4i)"=>"13", "start_time(5i)"=>"00", "end_time(1i)"=>"2023", "end_time(2i)"=>"3", "end_time(3i)"=>"6", "end_time(4i)"=>"21", "end_time(5i)"=>"00", "budget"=>"2", "dining_requirements"=>"adsd", "details_wheelchair_accessible_entrance"=>"false", "interests"=>["", "History", "Dining", "Drinks", "Activity", "Shopping"]} permitted: true>

    time = @params["start_time"].split(":")
    start_hour = time[0]
    start_minute = time[1]

    time = @params["end_time"].split(":")
    end_hour = time[0]
    end_minute = time[1]

    params = {
      interests: @params["interests"],
      # start_time: Time.new(
      #   @params["start_time(1i)"].to_i, # year
      #   @params["start_time(2i)"].to_i, # month
      #   @params["start_time(3i)"].to_i, # day
      #   @params["start_time(4i)"].to_i, # hour
      #   @params["start_time(5i)"].to_i, # minute
      #   0
      # ),
      # end_time: Time.new(
      #   @params["end_time(1i)"].to_i, # year
      #   @params["end_time(2i)"].to_i, # month
      #   @params["end_time(3i)"].to_i, # day
      #   @params["end_time(4i)"].to_i, # hour
      #   @params["end_time(5i)"].to_i, # minute
      #   0
      # ),
      start_time: Time.new(1, 1, 1, start_hour, start_minute, 0),
      end_time: Time.new(1, 1, 1, end_hour, end_minute, 0),

      dining_requirements: @params["dining_requirements"],
      dining_budget: @params["budget"],
      location: "51.512990,-0.131592"
    }

    interests = params[:interests]
    start_time = params[:start_time]
    end_time = params[:end_time]
    # puts start_time


    dining_requirements = params[:dining_requirements]
    dining_budget = params[:dining_budget]
    location = params[:location]

    # calculates duration of itinerary in mins
    duration = (end_time - start_time) / 60

    # sets dining option to lunch or dinner depending on day end time
    interests = set_dining_type(interests, end_time) if interests.include?('Dining')

    # progressivley combines event types if day duration is too short for all activities
    interests = combine_history_art_culture(interests) if calculate_time_needed(interests) > duration
    interests = combine_activity_attraction(interests) if calculate_time_needed(interests) > duration
    interests = combine_dining_drinks(interests) if calculate_time_needed(interests) > duration

    params[:interests] = interests
    params[:interests] = order_day(params)
    itinerary_template = event_template(params)

    itinerary_template

    # itinerary_template.each do |event|
    #   event.each { |x, y| puts "#{x} - #{y}"}
    #   puts "\n"
    # end

    # populate_itinerary(itinerary_template, start_time, end_time, dining_requirements, dining_budget, location)
  end

  def calculate_time_needed(interests)
    time_needed = 0
    interests.each { |interest| time_needed += TRAVEL_TIME + INTEREST_VALUES[:"#{interest}"][:time]}
    time_needed
  end

  def combine_history_art_culture(interests)
    if interests.include?('history' && 'art_culture')
      interests.delete('history')
      interests.delete('art_culture')
      interests << 'history_art_culture'
    end
    interests
  end

  def combine_activity_attraction(interests)
    if interests.include?('activity' && 'attraction')
      interests.delete('activity')
      interests.delete('attraction')
      interests << 'activity_attraction'
    end
    interests
  end

  def combine_dining_drinks(interests)
    if interests.include?('dining_dinner') && interests.include?('Drinks')
      interests.delete('dining_dinner')
      interests.delete('Drinks')
      interests << 'dining_dinner_drinks'
    elsif interests.include?('dining_lunch') && interests.include?('Drinks')
      interests.delete('dining_lunch')
      interests.delete('Drinks')
      interests << 'dining_lunch_drinks'
    end
    interests
  end

  def set_dining_type(interests, end_time)
    interests[interests.index('Dining')] = 'dining_lunch' if end_time <= DINING_TYPE_TIME
    interests[interests.index('Dining')] = 'dining_dinner' if end_time > DINING_TYPE_TIME
    interests
  end

  def order_day(params)
    interests = params[:interests]

    dining = false
    drinking = false

    new_event_order = []

    event_start = params[:start_time]
    event_end = params[:start_time]

    while interests.length.positive?
      interests.each do |interest|
        if (interests & ["dining_lunch", "dining_lunch_drinks"]).any?
          dining = true if event_end >= LUNCH_CUTOFF
        elsif (interests & ["dining_dinner", "dining_dinner_drinks"]).any?
          dining = true if event_end >= DINNER_CUTOFF
        else
          dining = false
        end


        drinking = true if event_end >= DRINKING_CUTOFF && interest == 'Drinks'

        if DINING_DRINKS.include?(interest) && dining
          event_start = event_end + TRAVEL_TIME * 60
          event_end = event_start + INTEREST_VALUES[:"#{interest}"][:time] * 60
          dining = false
          new_event_order << interest
        elsif (interest == 'Drinks') && drinking
          event_start = event_end + TRAVEL_TIME * 60
          event_end = event_start + INTEREST_VALUES[:"#{interest}"][:time] * 60
          new_event_order << interest
        elsif !DINING_DRINKS.include?(interest) && interest != 'Drinks' && !dining
          event_start = event_end + TRAVEL_TIME * 60
          event_end = event_start + INTEREST_VALUES[:"#{interest}"][:time] * 60
          new_event_order << interest
        else
          if interests.length == 1
            event_start = event_end + TRAVEL_TIME * 60
            event_end = event_start + INTEREST_VALUES[:"#{interest}"][:time] * 60
            new_event_order << interest
          elsif interests == ["dining_dinner", "Drinks"] || interests == ["dining_lunch", "Drinks"]
            puts interests
            puts interests.reverse
            interests.sort.each do |interest|
              event_start = event_end + TRAVEL_TIME * 60
              event_end = event_start + INTEREST_VALUES[:"#{interest}"][:time] * 60
              new_event_order << interest
            end
          end
        end
        new_event_order.each { |event| interests.delete(event) if interests.include?(event) }
      end
    end

    new_event_order
  end

  def event_template(params)
    itinerary_template = []

    order_number = 0
    event_start = params[:start_time]
    event_end = params[:start_time]

    params[:interests].each do |event|
      order_number += 1
      event_start = event_end + TRAVEL_TIME * 60
      event_end = event_start + INTEREST_VALUES[:"#{event}"][:time] * 60

      if ["dining_lunch", "dining_lunch_drinks", "dining_dinner", "dining_dinner_drinks"].include?(event)
        keyword = "#{params[:dining_requirements]}|#{INTEREST_VALUES[:"#{event}"][:keyword]}"
        maxprice = params[:dining_budget]
      else
        keyword = INTEREST_VALUES[:"#{event}"][:keyword]
        minprice = nil
        maxprice = nil
      end

      itinerary_template << {
        order_number: order_number,
        input_category: event,
        place_type: INTEREST_VALUES[:"#{event}"][:type],
        keyword: keyword,
        maxprice: maxprice,
        time_allocation: INTEREST_VALUES[:"#{event}"][:time],
        radius: INTEREST_VALUES[:"#{event}"][:radius],
        filter_type: INTEREST_VALUES[:"#{event}"][:filter_type],
        filter_ratings: INTEREST_VALUES[:"#{event}"][:filter_ratings],
        event_start_time: event_start.strftime('%H:%M'),
        event_end_time: event_end.strftime('%H:%M'),
        event_duration: INTEREST_VALUES[:"#{event}"][:time]
      }
    end

    itinerary_template
  end
end
