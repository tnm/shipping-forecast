require 'mechanize'

class ShippingForecast

  # Potential connectivity errors
  CONNECTION_ERRORS = [
    EOFError,
    Errno::ECONNRESET,
    Errno::EINVAL,
    Mechanize::ResponseCodeError,
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

  NUMBER_OF_LOCATIONS = 31

  # Public: Returns a hash of hash reports, each representing a location report.
  #
  # Contents of each report:
  #   warning: If there is a warning in effect, returns an hash with symbol keys.
  #            All values are strings.
  #        title:   The title of the warning, e.g., "Gale Warning"
  #        issued:  Time when the warning was issued, e.g., "Gale warning issued 9 April 15:26 UTC"
  #        summary: The text summary of the warning, e.g., "Southerly gale force 8 expected later"
  #
  #        *warning* is nil if there is no warning
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
  def self.[](location)
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

  # Public: Return weather reports just for those locations that have
  # warnings in effect
  #
  # Returns an array
  def self.all_warnings
    report.select { |_,r| r[:warning] }.map { |_,v| v }
  end

  def initialize; end

  # Internal: Return a weather report for all locations
  #
  # Returns a hash
  def raw_report
    @raw ||= build_data
  end

  private

  # Internal: Parse data from the BBC website to build the reports
  #
  # Returns a hash.
  def build_data
    agent = Mechanize.new

    # Raise an particular ConnectionToBBCError exception
    # on connectivity issues
    begin
      page = agent.get(URL)
    rescue *CONNECTION_ERRORS => error
      raise ConnectionToBBCError, error
    end

    locations = {}

    # For each location...
    1.upto(NUMBER_OF_LOCATIONS) do |i|
      area = page.search("#area-#{i}")
      location = area.search("h2").text

      # Warnings, if any
      warning = nil
      warning_detail = area.search(".warning-detail")

      # Search for the warning title
      warning_title = warning_detail.search("strong").text.gsub(':', '')

      # Check if there is a warning before proceeding
      if !warning_title.empty?
        warning = {}

        # Breakout the particular warnings
        warning[:title]   = warning_title
        warning[:issued]  = warning_detail.search(".issued").text
        warning[:summary] = warning_detail.search(".summary").text
      end

      # Build up all the conditions
      location_report = {}
      breakdown = area.search("ul").children.search("span")

      location_report[:warning]    = warning
      location_report[:location]   = location
      location_report[:wind]       = breakdown[0].text
      location_report[:seas]       = breakdown[1].text
      location_report[:weather]    = breakdown[2].text
      location_report[:visibility] = breakdown[3].text

      # Set the report for this location in the locations hash
      locations[location] = location_report
    end

    locations
  end
end
