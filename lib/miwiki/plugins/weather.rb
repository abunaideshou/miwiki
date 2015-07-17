module Miwiki
  module Plugins
    class Weather
      include Cinch::Plugin

      match /we (.+)/i    , :method => :we
      match /fc (.+)/i    , :method => :fc
      match /three (.+)/i , :method => :three

      def we message, query
        url =
          "http://api.wunderground.com/api/#{ config[:api_key] }/conditions/q/#{ CGI.escape query }.json"

        response = $mechanize_agent.get url
        weather  = JSON.parse(response.body)['current_observation']

        if weather.nil?
          message.reply "Couldn't find weather for #{ query }! Try being more specific."
          return
        end

        location    = weather['display_location']['full']
        condition   = weather['weather'].downcase.capitalize
        temperature = format_temps weather['temp_f'], weather['temp_c']
        wind        = "Wind #{ weather['wind_string'].uncapitalize }"
        humidity    = "Humidity: #{ weather['relative_humidity'] }"
        icon        = get_icon weather['icon']

        response =
          "#{ location }: #{ condition } #{ icon }, #{ temperature }. #{ wind }. #{ humidity }."

        message.reply response
      end

      def fc message, query
        url =
          "http://api.wunderground.com/api/#{ config[:api_key] }/forecast/q/#{ CGI.escape query }.json"

        page = $mechanize_agent.get url
        json = JSON.parse page.body

        forecast = json['forecast']['txt_forecast']['forecastday'][1]

        title = forecast['title'].downcase.capitalize
        body  = forecast['fcttext']

        message.reply "#{ title }: #{ body }"
      end

      def three message, query
        url =
          "http://api.wunderground.com/api/#{ config[:api_key] }/forecast/q/#{ CGI.escape query }.json"

        page = $mechanize_agent.get url
        json = JSON.parse page.body

        forecast = json['forecast']['simpleforecast']['forecastday'][1..-1]

        response = forecast.map do |day|
          weekday   = day['date']['weekday_short']
          high      = format_temps day['high']['fahrenheit'], day['high']['celsius']
          low       = format_temps day['low']['fahrenheit'], day['low']['celsius']
          condition = day['conditions']
          icon      = get_icon day['icon']

          "#{ weekday }: #{ condition } #{ icon }. High: #{ high }, Low: #{ low }."
        end.join "\n"

        message.reply response
      end

      private

      def format_temps fahrenheit, celsius
        "#{ fahrenheit }˚F/#{ celsius }˚C"
      end

      def get_icon name
        name.gsub! /^chance/, ''

        case name
        when 'clear', 'mostlysunny', 'sunny'
          '☀️ '
        when 'cloudy', 'fog', 'hazy', 'mostlycloudy'
          '☁️ '
        when 'flurries'
          '💨 '
        when 'partlycloudy', 'partlysunny'
          '⛅️ '
        when 'rain', 'sleet'
          '☔️ '
        when 'snow'
          '❄️ '
        when 'tstorms'
          '⚡️ '
        end.strip
      end
    end
  end
end
