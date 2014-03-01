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
=> #<OpenStruct warning=#<OpenStruct title="Gale Warning", issued="Gale warning issued 2 January 15:47 UTC", summary="Southeasterly gale force 8, increasing severe gale force 9 later">, location="Viking", wind="Southerly or southeasterly 7 to severe gale 9.", seas="Rough or very rough, occasionally high later.", weather="Rain or squally showers.", visibility="Good, occasionally poor.">
```

This gives you an OpenStruct object with these attributes:

* **warning** — If there is a warning in effect, returns an OpenStruct
object with attributes:
   * **title** – The title of the warning, e.g., "Gale Warning"
   * **issued** – When the warning was issued
   * **summary** – The text summary of the warning

* **wind** – The wind conditions, with degree and speed

* **seas** – The current sea conditions

* **visibility** – The current visibility report

You can also get all the forecasts using:

```ruby
ShippingForecast.all
```

To get a list of all available locations, as strings:

```ruby
ShippingForecast.locations
=> ["Bailey", "Biscay", "Cromarty", "Dogger", "Dover", "Faeroes", "Fair Isle", "Fastnet", "Fisher", "FitzRoy", "Forth", "Forties", "German Bight", "Hebrides", "Humber", "Irish Sea", "Lundy", "Malin", "North Utsire", "Plymouth", "Portland", "Rockall", "Shannon", "Sole", "South Utsire", "Southeast Iceland", "Thames", "Trafalgar", "Tyne", "Viking", "Wight"]
```

Example
---------

```ruby
> tyne = ShippingForecast["Tyne"]
> tyne.warning.summary
=> "Gale force 8 veering southerly and increasing severe gale force 9 later"
> tyne.wind
=> "South or southeast veering southwest, 6 to gale 8, occasionally severe gale 9."
tyne.weather
=> "Rain then squally showers."
tyne.seas
=> "Moderate or rough, becoming rough or very rough."
tyne.visibility
=> "Good, occasionally poor."
```

The content of the Shipping Forecast itself is copyright of the BBC. This
library is MIT licensed.
