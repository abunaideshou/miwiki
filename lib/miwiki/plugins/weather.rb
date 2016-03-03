module Miwiki
  module Plugins
    class Weather
      include Cinch::Plugin

      match /we (.+)/i    , :method => :we

      def we message, query

        geocode  = Geocoder.search(query).first.data
        location = geocode['formatted_address']

        lat = geocode['geometry']['location']['lat'].to_i
        lon = geocode['geometry']['location']['lng'].to_i

        url      = "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&APPID=#{config[:api_key]}"
        response = JSON.parse $mechanize_agent.get(url).body

        description = response['weather'].first['description'].capitalize

        temp_unit   = Unit.new "#{response['main']['temp']} tempK"
        temperature = format_temps temp_unit.convert_to('tempF').scalar.round(1), temp_unit.convert_to('tempC').scalar.round(1)

        wind_speed = "#{response['wind']['speed']} MPH"
        wind_dir   = compass_direction response['wind']['deg']

        humidity = "#{response['main']['humidity']}%"

        weather = "#{location}: #{description} #{temperature}. Wind #{wind_dir} at #{wind_speed}. Humidity #{humidity}."

        message.reply weather
      end

      private

      DIRECTIONS = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]

      def compass_direction degree
        lookup = ((degree / 22.5) + 0.5).to_i
        DIRECTIONS[lookup % 16]
      end

      def format_temps fahrenheit, celsius
        "#{ fahrenheit }˚F/#{ celsius }˚C"
      end
    end
  end
end
