require 'mechanize'
require 'ostruct'

class ShippingForecast
  URL = "http://www.bbc.co.uk/weather/coast_and_sea/shipping_forecast"

  # Public: Returns a hash of OpenStruct objects, each representint a location report
  def self.report
    @raw_report ||= new.raw_report
  end

  # Public: Returns a forecast for a particular location
  def self.[] location
    report[location]
  end

  # Public: Returns all forecasts
  def self.all
    report
  end

  # Public: Returns an array of strings of each available location
  def self.locations
    report.keys.sort
  end

  def initialize
    @built = false
    @data  = nil
  end

  def raw_report
    build_data unless @built
    @data
  end

  private

  def build_data
    agent = Mechanize.new
    page = agent.get(URL)

    locations = {}

    1.upto(31) do |i|
      area = page.search("#area-#{i}")
      location = area.search("h2").text

      # Warnings, if any
      warning = OpenStruct.new
      warning_detail = area.search(".warning-detail")
      warning.title   = warning_detail.search("strong").text.gsub(':', '')
      warning.issued  = warning_detail.search(".issued").text
      warning.summary = warning_detail.search(".summary").text

      # Build the hash
      area_hash = OpenStruct.new
      breakdown  = area.search("ul").children.search("span")

      area_hash.warning    = warning
      area_hash.location   = location
      area_hash.wind       = breakdown[0].text
      area_hash.seas       = breakdown[1].text
      area_hash.weather    = breakdown[2].text
      area_hash.visibility = breakdown[3].text

      locations[location] = area_hash
    end

    @data = locations
    @built = true
  end
end
