require "test/unit"
require "./lib/shipping_forecast"

class ShippingForecastTest < Test::Unit::TestCase

  LOCATIONS =
    ["Bailey",
     "Biscay",
     "Cromarty",
     "Dogger",
     "Dover",
     "Faeroes",
     "Fair Isle",
     "Fastnet",
     "Fisher",
     "FitzRoy",
     "Forth",
     "Forties",
     "German Bight",
     "Hebrides",
     "Humber",
     "Irish Sea",
     "Lundy",
     "Malin",
     "North Utsire",
     "Plymouth",
     "Portland",
     "Rockall",
     "Shannon",
     "Sole",
     "South Utsire",
     "Southeast Iceland",
     "Thames",
     "Trafalgar",
     "Tyne",
     "Viking",
     "Wight"]

  def test_report_type
    assert ShippingForecast.report.is_a?(Hash)
  end

  def test_report_includes_viking
    assert_not_nil ShippingForecast["Viking"]
  end

  def test_locations_shows_all_locations
    assert_equal LOCATIONS, ShippingForecast.locations
  end

  def test_all_is_same_as_report
    assert_equal ShippingForecast.report, ShippingForecast.all
  end
end
