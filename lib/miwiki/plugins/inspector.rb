module Miwiki
  module Plugins
    class Inspector
      include Cinch::Plugin

      match %r{(https?:\/\/.*?)(?:\s|$|,|\.\s|\.$)}i, :use_prefix => false

      def execute message, url
        page = $mechanize_agent.head url

        if page.is_a? Mechanize::Page
          page = $mechanize_agent.get url

          if url.match %r{youtube\.com/watch|youtu\.be/}i
            title = page.at('#eow-title').text || ''
            title = title.gsub("\n", ' ').strip.truncate

            preview = page.at('#eow-description').text || ''
            preview = preview.gsub("\n", ' ').strip.truncate

            response = title
            response += " (#{ preview })" unless preview.empty?

            message.reply response

          else
            message.reply page.title.strip
          end
        else
          content_type = page.response['content-type']
          filesize     = Filesize.from("#{ page.response['content-length'] } B").pretty
          filename     = page.response['content-disposition'][/"(.*)"/, 1] rescue nil

          response = "#{ content_type }, #{ filesize }"
          response = "#{ filename } (#{ response })" if filename

          message.reply response
        end
      end
    end
  end
end
