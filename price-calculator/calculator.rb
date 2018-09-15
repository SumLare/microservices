require 'ostruct'

class Calculator
  METERS_IN_KILOMETER = 1000.0
  SECONDS_IN_MINUTE = 60.0

  def initialize(duration_in_seconds, meters)
    @duration_in_seconds = duration_in_seconds
    @meters = meters
    # stubbed tariff object
    @tariff = OpenStruct.new(service_delivery_price: 250, price_per_minute: 20,
                price_per_kilometer: 20, min_price: 500
              )
  end

  def call
    calculated_price = @tariff.service_delivery_price +
      @tariff.price_per_minute * @duration_in_seconds / SECONDS_IN_MINUTE +
      @tariff.price_per_kilometer * @meters / METERS_IN_KILOMETER

    total_price = [calculated_price, @tariff.min_price].max

    { total_price: total_price }
  end
end
