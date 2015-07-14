module Miwiki
  module Plugins
    class YouTube
      include Cinch::Plugin

      match /yt (.+)/i

      def execute message, query
        url  = "https://www.youtube.com/results?search_query=#{ CGI.escape query }"
        page = $mechanize_agent.get url

        title_element = page.at '.yt-lockup-title a'

        title = title_element.attributes['title'].value
        link  = title_element.attributes['href'].value

        message.reply "#{ title } https://youtube.com#{ link }"
      end
    end
  end
end
