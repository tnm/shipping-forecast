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
      assert_not_nil_nor_empty ShippingForecast[location]
    end
  end

  def test_locations_shows_all_locations
    assert_equal LOCATIONS, ShippingForecast.locations
  end

  def test_all_method_is_same_as_report_method
    assert_equal ShippingForecast.report, ShippingForecast.all
  end

  def test_report_includes_all_reports
    assert_equal ShippingForecast::NUMBER_OF_LOCATIONS, ShippingForecast.report.count
  end

  def test_report_includes_seas
    LOCATIONS.each do |location|
      assert_not_nil_nor_empty ShippingForecast[location][:seas]
    end
  end

  def test_report_includes_wind
    LOCATIONS.each do |location|
      assert_not_nil_nor_empty ShippingForecast[location][:wind]
    end
  end

  def test_report_includes_wind_number
    LOCATIONS.each do |location|
      assert /[0-9]/ =~ ShippingForecast[location][:wind]
    end
  end

  def test_report_includes_weather
    LOCATIONS.each do |location|
      assert_not_nil_nor_empty ShippingForecast[location][:weather]
    end
  end

  def test_report_includes_visibility
    LOCATIONS.each do |location|
      assert_not_nil_nor_empty ShippingForecast[location][:visibility]
    end
  end

  def test_report_warning_is_a_hash_if_warning
    LOCATIONS.each do |location|
      assert ShippingForecast[location][:warning].is_a?(Hash) if ShippingForecast[location][:warning]
    end
  end
  
  def test_warning_includes_title_if_warning
    LOCATIONS.each do |location|
      assert_not_nil_nor_empty ShippingForecast[location][:warning][:title] if ShippingForecast[location][:warning]
    end
  end

  def test_warning_includes_issued_if_warning
    LOCATIONS.each do |location|
      assert_not_nil_nor_empty ShippingForecast[location][:warning][:issued] if ShippingForecast[location][:warning]
    end
  end

  def test_warning_includes_summary_if_warning
    LOCATIONS.each do |location|
      assert_not_nil_nor_empty ShippingForecast[location][:warning][:summary] if ShippingForecast[location][:warning]
    end
  end

  def assert_not_nil_nor_empty(exp, msg=nil)
    msg = message(msg) { "<#{exp}> expected to not be nil or empty" }
    assert(!exp.nil? && !exp.empty?, msg)
  end
end
