module Miwiki
  module Plugins
    class Otaku
      include Cinch::Plugin

      match /air(?:\s|$)(yesterday|today|tomorrow)?/i

      def execute message, day
        day ||= 'today'

        date =
          case day
          when 'yesterday'
            Date.today - 1
          when 'today'
            Date.today
          when 'tomorrow'
            Date.today + 1
          end

        url  = "http://animecalendar.net/#{ date.year }/#{ date.month }/#{ date.day }"
        page = $mechanize_agent.get url

        schedule = page.at('#calendarDay').search('table[align="center"] > tr')[2..-1]

        show_details = schedule.map do |row|
          time = row.at('.hour').text.strip
          show = row.at('h3').text.strip
          
          "#{ show } (#{ time })"
        end

        response  = "#{ day.capitalize }'s schedule: "
        response += show_details.join ', '

        message.reply response
      end
    end
  end
end
