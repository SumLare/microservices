require 'minitest/autorun'
require_relative '../calculator'

class PriceCalculatorTest < Minitest::Test
  def setup
    @short_distance = Calculator.new(1, 1)
    @long_distance = Calculator.new(1000, 10_000)
  end

  def test_short_distance_ride
    assert_equal 500, @short_distance.call[:total_price]
  end

  def test_long_distance_ride
    assert_operator @long_distance.call[:total_price], :>, 500
  end
end
