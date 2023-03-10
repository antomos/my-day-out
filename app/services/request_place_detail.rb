class RequestPlaceDetail < ApplicationRecord
  def initialize(place_details)
    @place_details = place_details
  end

  def perform
    fetch_place_details
  end

  private

  def fetch_place_details

    # key_to_symbols = @place_details
    # @place_details = {}

    # key_to_symbols.each do |key, value|
    #   @place_details[key.to_sym] = value
    # end

    url = generate_url

    # https = Net::HTTP.new(url.host, url.port)
    # https.use_ssl = true

    # request = Net::HTTP::Get.new(url)

    # response = https.request(request)

    # response_json = response.read_body
    # JSON.parse(response_json)

    # TEST JSONS
    filepath = "app/services/test_results/place_details_test.json"
    serialized_places = File.read(filepath)
    JSON.parse(serialized_places)
  end

  def generate_url
    key = ENV["GOOGLE_API_KEY"]
    URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{@place_details[:place_id]}&key=#{key}")
  end
end
