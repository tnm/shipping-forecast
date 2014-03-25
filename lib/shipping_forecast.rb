require 'mechanize'
require 'ostruct'

class ShippingForecast

  # Potential connectivity errors
  HTTP_ERRORS = [
    EOFError,
    Errno::ECONNRESET,
    Errno::EINVAL,
    Net::HTTPBadResponse,
    Net::HTTPHeaderSyntaxError,
    Net::ProtocolError,
    SocketError,
    Timeout::Error
  ]

  # Unique error class
  class ConnectionToBBCError < Exception; end

  URL = "http://www.bbc.co.uk/weather/coast_and_sea/shipping_forecast"

  # Public: Returns a hash of OpenStruct objects, each representing a location report.
  #
  # Contents of each report:
  #   warning: If there is a warning in effect, returns an OpenStruct object with attributes:
  #        title:   The title of the warning, e.g., "Gale Warning"
  #        issued:  When the warning was issued
  #        summary: The text summary of the warning
  #
  #   wind:       The wind conditions
  #   seas:       The sea conditions
  #   weather:    The weather report
  #   visibility: The visibility report
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

  # Return a weather report for all locations
  def raw_report
    build_data unless @built
    @data
  end

  private

  # Parse data from the BBC website to build the reports.
  def build_data
    agent = Mechanize.new

    # Raise an particular exception on connectivity issues
    begin
      page = agent.get(URL)
    rescue *HTTP_ERRORS => e
      raise ConnectionToBBCError, e
    end

    locations = {}

    # For each location...
    1.upto(31) do |i|
      area = page.search("#area-#{i}")
      location = area.search("h2").text

      # Warnings, if any
      warning = OpenStruct.new
      warning_detail = area.search(".warning-detail")

      # Breakout the particular warnings
      warning.title   = warning_detail.search("strong").text.gsub(':', '')
      warning.issued  = warning_detail.search(".issued").text
      warning.summary = warning_detail.search(".summary").text

      # Build up all the conditions
      location_report = OpenStruct.new
      breakdown  = area.search("ul").children.search("span")

      location_report.warning    = warning
      location_report.location   = location
      location_report.wind       = breakdown[0].text
      location_report.seas       = breakdown[1].text
      location_report.weather    = breakdown[2].text
      location_report.visibility = breakdown[3].text

      # Set the report for this location to the locations hash
      locations[location] = location_report
    end

    @data = locations
    @built = true
  end
end
