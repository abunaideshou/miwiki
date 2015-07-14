module Miwiki
  module Plugins
    class Booru
      include Cinch::Plugin

      match /booru (.+)/

      def execute message, tags
        url  = "http://safebooru.donmai.us/posts/random?login=miwiki-bot&api_key=e9VwzTgtJ_7YRSaxNvjTPanwG18zn_fK_oJqiIX_tfE&tags=#{ CGI.escape tags }"
        page = $mechanize_agent.get url

        image_path = page.at('#image-container').attributes['data-file-url'].value
        image_url  = "http://safebooru.donmai.us#{ image_path }"

        message.reply image_url
      end
    end
  end
end
