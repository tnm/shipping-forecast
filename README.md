shipping forecast
==================

This is a simple Ruby library for accessing the BBC's public [Shipping
Forecast](http://www.bbc.co.uk/weather/coast_and_sea/shipping_forecast).

Usage
-------

Install the gem. You can get one from RubyGems:

```
gem install shipping-forecast
```

It uses [mechanize](https://github.com/sparklemotion/mechanize).

The API is straight-forward. You can use `[]` notation to lookup
a location (like "Viking" or "Plymouth") and get a forecast report:

```ruby
require 'shipping_forecast'

viking = ShippingForecast["Viking"]
=> {:warning=>nil, :location=>"Viking", :wind=>"Variable 3 or 4 until later in west, otherwise southerly 4 or 5.", :seas=>"Slight or moderate.",
:weather=>"Occasional rain or drizzle.", :visibility=>"Good occasionally poor."}
```

This gives you a hash with these keys (all values are strings): 

* **`:location`** — The location name
* **`:warning`** — If there is a warning in effect, returns a hash
object with keys:
   * **`:title`** – The title of the warning, e.g., "Gale Warning"
   * **`:issued`** – When the warning was issued
   * **`:summary`** – The text summary of the warning

* **`:wind`** – The wind conditions, with degree and speed

* **`:seas`** – The current sea conditions

* **`:visibility`** – The current visibility report

You can also get all the forecasts using:

```ruby
ShippingForecast.all
```

That returns a hash with keys of location names, so `ShippingForecast.all["Viking"]` is equivalent to
`ShippingForecast["Viking"]`.

To get a list of all available locations, as an array of strings:

```ruby
ShippingForecast.locations
=> ["Bailey", "Biscay", "Cromarty", "Dogger", "Dover", "Faeroes", "Fair Isle", "Fastnet", "Fisher", "FitzRoy", "Forth", "Forties", "German Bight", "Hebrides", "Humber", "Irish Sea", "Lundy", "Malin", "North Utsire", "Plymouth", "Portland", "Rockall", "Shannon", "Sole", "South Utsire", "Southeast Iceland", "Thames", "Trafalgar", "Tyne", "Viking", "Wight"]
```

To run the tests you can just run:

```
rake
```

Note that the tests do make HTTP requests to the BBC's website.
This is to verify that the structure of the BBC's Shipping
Forecast markup will still be parsed correctly by this program.

There is also a simple script you can use to lookup the forecasts from
the command line. You can optionally give the name of a location to just
get a specific forecast.

```
bin/forecast <[location name]>
```

Example
---------

```ruby
> tyne = ShippingForecast["Tyne"]
> tyne[:warning][:summary]
=> "Gale force 8 veering southerly and increasing severe gale force 9 later"
> tyne[:wind]
=> "South or southeast veering southwest, 6 to gale 8, occasionally severe gale 9."
tyne[:weather]
=> "Rain then squally showers."
tyne[:seas]
=> "Moderate or rough, becoming rough or very rough."
tyne[:visibility]
=> "Good, occasionally poor."
```

The content of the Shipping Forecast itself is copyright of the BBC. This
library is MIT licensed.
