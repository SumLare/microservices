require 'typhoeus'

class RideInfoRequest
   RIDE_INFO_HOST = 'ride-info'

  def initialize(start_coords, end_coords)
    @start_coords = start_coords
    @end_coords = end_coords
  end

  def call
    info_response = get_info

    begin
      JSON.parse(info_response.body, object_class: OpenStruct)
    rescue JSON::ParserError
      return { error: "Parsing error: #{info_response.body}" }
    end
  end

  private

  def get_info
    url = "http://#{RIDE_INFO_HOST}:8000/ride_info?start_coords=#{@start_coords}&end_coords=#{@end_coords}"

    Typhoeus::Request.get(url, timeout: 100)
  end
end
