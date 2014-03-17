require "test/unit"
require "./lib/shipping_forecast"

class ShippingForecastTest < Test::Unit::TestCase
  def test_report_type
    assert ShippingForecast.report.is_a?(Hash)
  end

  def test_report_includes_viking
    assert_not_nil ShippingForecast["Viking"]
  end
end
