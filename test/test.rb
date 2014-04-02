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

  def test_report_includes_each_location
    LOCATIONS.each do |location|
      assert_not_nil ShippingForecast[location]
    end
  end

  def test_locations_shows_all_locations
    assert_equal LOCATIONS, ShippingForecast.locations
  end

  def test_all_is_same_as_report
    assert_equal ShippingForecast.report, ShippingForecast.all
  end

  def test_report_includes_seas
    LOCATIONS.each do |location|
      assert_not_nil ShippingForecast[location][:seas]
    end
  end

  def test_report_includes_wind
    LOCATIONS.each do |location|
      assert_not_nil ShippingForecast[location][:wind]
    end
  end

  def test_report_includes_wind_number
    LOCATIONS.each do |location|
      assert /[0-9]/ =~ ShippingForecast[location][:wind]
    end
  end

  def test_report_includes_weather
    LOCATIONS.each do |location|
      assert_not_nil ShippingForecast[location][:weather]
    end
  end

  def test_report_includes_visibility
    LOCATIONS.each do |location|
      assert_not_nil ShippingForecast[location][:visibility]
    end
  end

  def test_report_warning_is_a_hash
    LOCATIONS.each do |location|
      assert_not_nil ShippingForecast[location][:warning].is_a?(Hash)
    end
  end
end
