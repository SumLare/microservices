require 'json'
require_relative 'calculator'
require_relative 'ride_info_request'

class CalculatorResponse
  def call(env)
    return [404, {}, ['Only /price request is valid']] if env['PATH_INFO'] != '/price'

    req = Rack::Request.new(env)
    start_coords, end_coords = req.params['start_coords'], req.params['end_coords']
    info = ride_info(start_coords, end_coords)

    body = total_price(info.Seconds, info.Meters)

    [200, {'Content-Type' => 'application/json'}, [body.to_json]]
  end

  private

  def total_price(seconds, meters)
    Calculator.new(seconds, meters).call
  end

  def ride_info(start_coords, end_coords)
    RideInfoRequest.new(start_coords, end_coords).call
  end
end
