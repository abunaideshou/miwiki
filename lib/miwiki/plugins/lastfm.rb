module Miwiki
  module Plugins
    class LastFM
      include Cinch::Plugin

      match /np (\S+)/i

      def execute message, username
        page       = $mechanize_agent.get "http://last.fm/user/#{ username }"
        track_info = page.at('.chartlist-name').search('a').map { |n| n.text }

        if page.at('.chartlist-now-scrobbling')
          message.reply "#{ username } is now playing #{ track_info[1] } by #{ track_info[0] } ♪"
        else
          message.reply "#{ username } last played #{ track_info[1] } by #{ track_info[0] } ♪"
        end
      end
    end
  end
end
