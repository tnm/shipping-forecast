Gem::Specification.new do |s|
  s.name    = 'shipping-forecast'
  s.version = '0.0.1'
  s.summary = "Ruby wrapper for the BBC's shipping forecast"

  s.authors  = "Ted Nyman"
  s.homepage = "https://github.com/tnm/shipping-forecast"
  s.files       = ["lib/shipping_forecast.rb"]
  s.license  = "MIT"

  s.add_dependency 'mechanize'
end
