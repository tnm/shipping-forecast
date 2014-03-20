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

  def test_report_includes_seas
    assert_not_nil ShippingForecast["Viking"].seas
  end

  def test_report_includes_wind
    assert_not_nil ShippingForecast["Viking"].wind
  end

  def test_report_includes_weather
    assert_not_nil ShippingForecast["Viking"].weather
  end

  def test_report_includes_visibility
    assert_not_nil ShippingForecast["Viking"].visibility
  end

  def test_report_warning_is_an_open_struct
    assert ShippingForecast["Viking"].warning.is_a?(OpenStruct)
  end
end
