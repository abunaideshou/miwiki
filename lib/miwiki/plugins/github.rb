module Miwiki
  module Plugins
    class GitHub
      include Cinch::Plugin

      match /github (.+)/i

      def execute message, query
        url  = "https://github.com/search?utf8=%E2%9C%93&q=#{ CGI.escape query}"
        page = $mechanize_agent.get url

        link = page.at '.repo-list-name a'
        href = "https://github.com#{ link.attributes['href'].value }"
        name = link.text.strip

        description = page.at('.repo-list-description').text.strip

        message.reply "#{ name } – #{ description } #{ href }"
      end
    end
  end
end
