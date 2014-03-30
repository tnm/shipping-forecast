require 'mechanize'
require 'ostruct'

class ShippingForecast

  # Potential connectivity errors
  CONNECTION_ERRORS = [
    EOFError,
    Errno::ECONNRESET,
    Errno::EINVAL,
    Net::HTTPBadResponse,
    Net::HTTPHeaderSyntaxError,
    Net::ProtocolError,
    SocketError,
    Timeout::Error
  ]

  # Unique error class for connection problems
  class ConnectionToBBCError < StandardError; end

  # URL for the Shipping Forecast content
  URL = ENV["SHIPPING_FORECAST_URL"] ||= "https://www.bbc.com/weather/coast_and_sea/shipping_forecast"

  # Public: Returns a hash of OpenStruct objects, each representing a location report.
  #
  # Contents of each report:
  #   warning: If there is a warning in effect, returns an OpenStruct object with attributes:
  #        title:   The title of the warning, e.g., "Gale Warning"
  #        issued:  When the warning was issued
  #        summary: The text summary of the warning
  #
  #        warning is nil if there is no warning
  #
  #   wind:       The wind conditions
  #   seas:       The sea conditions
  #   weather:    The weather report
  #   visibility: The visibility report
  def self.report
    @raw_report ||= new.raw_report
  end

  # Public: Returns a forecast for a particular location
  #
  # Returns a hash
  def self.[] location
    report[location]
  end

  # Public: Returns all forecasts
  #
  # Returns an array
  def self.all
    report
  end

  # Public: Returns an array of strings of each available location
  #
  # Returns an array
  def self.locations
    report.keys.sort
  end

  # Public: Return weather reports for any locations with warnings
  #
  # Returns an array
  def self.all_warnings
    report.select{|_,r| r.warning}.map{|_,v| v}
  end

  def initialize; end

  # Return a weather report for all locations
  def raw_report
    @raw ||= build_data
  end

  private

  # Parse data from the BBC website to build the reports.
  def build_data
    agent = Mechanize.new

    # Raise an particular exception on connectivity issues
    begin
      page = agent.get(URL)
    rescue *CONNECTION_ERRORS => e
      raise ConnectionToBBCError, e
    end

    locations = {}

    # For each location...
    1.upto(31) do |i|
      area = page.search("#area-#{i}")
      location = area.search("h2").text

      # Warnings, if any
      warning = nil
      warning_detail = area.search(".warning-detail")

      # Search for the warning title. We'll use this to check if there is
      # a warning at all.
      warning_title = warning_detail.search("strong").text.gsub(':', '')

      # Check if there is a warning before proceeding
      if !warning_title.empty?
        warning = OpenStruct.new

        # Breakout the particular warnings
        warning.title   = warning_title
        warning.issued  = warning_detail.search(".issued").text
        warning.summary = warning_detail.search(".summary").text
      end

      # Build up all the conditions
      location_report = OpenStruct.new
      breakdown = area.search("ul").children.search("span")

      location_report.warning    = warning
      location_report.location   = location
      location_report.wind       = breakdown[0].text
      location_report.seas       = breakdown[1].text
      location_report.weather    = breakdown[2].text
      location_report.visibility = breakdown[3].text

      # Set the report for this location to the locations hash
      locations[location] = location_report
    end

    locations
  end
end
