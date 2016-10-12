module Miwiki
  module Plugins
    class Nyaa
      include Cinch::Plugin

      match /nyaa (.+)/i

      def execute message, query
        url  = "http://www.nyaa.se/?page=search&term=#{ CGI.escape query }&sort=2"
        page = $mechanize_agent.get url

        link = page.at '.tlistname a'
        href = "https:#{ link.attributes['href'].value }"
        name = link.text.strip

        message.reply "#{ name } #{ href }"
      end
    end
  end
end
