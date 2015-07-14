module Miwiki
  module Plugins
    class Inspector
      include Cinch::Plugin

      match %r{(https?:\/\/.*?)(?:\s|$|,|\.\s|\.$)}i, :use_prefix => false

      def execute message, url
        page = $mechanize_agent.head url

        if page.is_a? Mechanize::Page
          page = $mechanize_agent.get url

          if check_youtube(url)
            title = page.at('#eow-title').text || ''
            title = title.gsub(/\n/, ' ').strip.truncate

            preview = page.at('#eow-description').text || ''
            preview = preview.gsub(/\n/, ' ').strip.truncate

            response = title
            response += " (#{ preview })" unless preview.empty?

            message.reply response

          elsif match_data = check_4chan(url)
            title       = page.at('.opContainer .subject').text || ''
            board       = match_data[1]
            post_number = url.match(/#p(\d+)/)[1] rescue nil

            preview_selector = 
              if post_number
                ".postMessage#m#{ post_number }"
              else
                '.opContainer .postMessage'
              end

            preview = page.at(preview_selector).text || ''
            preview = preview.strip.gsub(/\n/, ' ').truncate
            
            response = board
            response += " - #{ title }"   unless title.empty?
            response += " (#{ preview })" unless preview.empty?

            message.reply response

          else
            message.reply page.title

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

      private

      def check_youtube url
        url.match %r{youtube\.com/watch|youtu\.be/}i
      end

      def check_4chan url
        url.match %r{boards\.4chan\.org(/\w+/)thread/\d+/\S+}i
      end
    end
  end
end
