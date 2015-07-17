module Miwiki
  module Plugins
    class Google
      include Cinch::Plugin

      match /image (.+)/, :method => :image

      def image message, query
        url =
          "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&safe=active&q=#{ CGI.escape query }"

        page  = $mechanize_agent.get url
        json  = JSON.parse page.body
        image = json['responseData']['results'][0]

        content_text = image['contentNoFormatting']
        image_url    = image['unescapedUrl']

        message.reply "#{ content_text } #{ image_url }"
      end
    end
  end
end
