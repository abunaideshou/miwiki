module Miwiki
  module Plugins
    class Weather
      include Cinch::Plugin

      match /we (.+)/i

      def execute message, query
        url = "http://api.openweathermap.org/data/2.5/weather?units=imperial&q=#{ CGI.escape query }"

        response = $mechanize_agent.get url
        weather  = JSON.parse response.body

        city    = weather['name']
        country = weather['sys']['country']

        condition = weather['weather'][0]['description'].capitalize

        temperature = weather['main']['temp']
        fahrenheit  = temperature.to_i
        celsius     = ((temperature - 32) * (5.0/9.0)).to_i

        wind_speed = weather['wind']['speed'].to_i
        humidity   = weather['main']['humidity']

        sunrise = Time.at weather['sys']['sunrise']
        sunset  = Time.at weather['sys']['sunset']

        sunrise_delta = Time.now - sunrise
        sunset_delta  = Time.now - sunset

        sunrise = "Sunrise #{ sunrise_delta.relative_occurence }"
        sunset  = "Sunset #{ sunset_delta.relative_occurence }"

        response = "#{ city } (#{ country }): #{ condition }, #{ fahrenheit }˚F/#{ celsius }˚C. Wind: #{ wind_speed } MPH. Humidity: #{ humidity }%. #{ sunrise }. #{ sunset }."

        message.reply response
      end
    end
  end
end
