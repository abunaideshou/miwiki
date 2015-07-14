module Miwiki
  module Plugins
    class Otaku
      include Cinch::Plugin

      match /air(?:\s|$)(yesterday|today|tomorrow)?/i , :method => :air
      match /(anime|manga) (.+)/i                     , :method => :mal

      def mal message, type, query
        @authed_agent ||= Mechanize.new do |agent|
          agent.auth config[:user], config[:password]
        end

        url = "http://myanimelist.net/api/#{ type }/search.xml?q=#{ CGI.escape query }"

        entry = @authed_agent.get(url).at type

        title    = entry.at('title').text
        synopsis = entry.at('synopsis').text.split('<br />').first.truncate 280
        kind     = entry.at('type').text
        status   = entry.at('status').text
        year     = entry.at('start_date').text.split('-').first
        id       = entry.at('id').text

        message.reply "#{ title } (#{ kind }, #{ year }, #{ status.downcase }): #{ synopsis } http://myanimelist.net/#{ type }/#{ id }"
      end

      def air message, day
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
