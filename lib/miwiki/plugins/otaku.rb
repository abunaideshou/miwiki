module Miwiki
  module Plugins
    class Otaku
      include Cinch::Plugin

      match /air(?:\s|$)(yesterday|today|tomorrow)?/i , :method => :air
      match /(anime|manga) (.+)/i                     , :method => :mal

      match /jp/i, :method => :jp

      def mal message, type, query
        @authed_agent ||= Mechanize.new do |agent|
          agent.auth config[:user], config[:password]
        end

        url = "http://myanimelist.net/api/#{ type }/search.xml?q=#{ CGI.escape query }"

        entry = @authed_agent.get(url).at type

        synopsis = HTMLEntities.new.decode entry.at('synopsis').text
        synopsis = synopsis.split('<br />').first.truncate 280
        title    = entry.at('title').text
        kind     = entry.at('type').text
        status   = entry.at('status').text.downcase
        year     = entry.at('start_date').text.split('-').first
        id       = entry.at('id').text
        url      = "http://myanimelist.net/#{ type }/#{ id }"

        message.reply "#{ title } (#{ kind }, #{ year }, #{ status }): #{ synopsis } #{ url }"
      end

      def jp message
        time = Time.now.getlocal('+09:00').strftime('%a %l:%M %p')
        message.reply "Time in Tokyo: #{ time }"
      end

      ONE_DAY = 60 * 60 * 24

      def air message, day
        day ||= 'today'

        local_time =
          case day
          when 'yesterday'
            Time.now - ONE_DAY
          when 'today'
            Time.now
          when 'tomorrow'
            Time.now + ONE_DAY
          end.getlocal '+09:00'

        url  = "http://animecalendar.net/#{ local_time.year }/#{ local_time.month }/#{ local_time.day }"
        page = $mechanize_agent.get url

        schedule = page.at('#calendarDay').search('table[align="center"] > tr')[2..-1]

        show_details = schedule.map do |row|
          time = row.at('.hour').text.strip
          show = row.at('h3').text.strip
          
          "#{ show } (#{ time })"
        end

        response  = "#{ local_time.strftime '%A' }'s schedule (JST):"
        response += show_details.join ', '

        message.reply response
      end
    end
  end
end
