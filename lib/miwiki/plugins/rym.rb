module Miwiki
  module Plugins
    class RYM
      include Cinch::Plugin

      match /rym (.*)/i

      def execute message, query
        query = "#{ query } site:rateyourmusic.com"
        url   = "https://google.com/search?q=#{ CGI.escape query }"
        page  = $mechanize_agent.get url

        url  = page.at('h3.r a').attributes['href'].value.match(/url=([^&]*)/i)[1]
        page = $mechanize_agent.get url

        if url =~ /rateyourmusic\.com\/release\//i
          name   = page.at('.album_title').text.split(/\n/)[0].strip
          year   = page.at('td a b').text.strip
          artist = page.at('a.artist').text.strip
          genres = page.search('.genre').map { |n| n.text.strip }.take 3

          message.reply "#{ artist } - #{ name } (#{ year }). #{ genres.join ', ' }. #{ page.uri }"

        elsif url =~ /rateyourmusic.com\/artist\//i
          name   = page.at('.artist_name_hdr').text
          genres = page.search('.genre').map { |n| n.text.strip }.take(3)

          albums = page.search('#disco_type_s .disco_release').map { |release|
            title = release.at('a.album').text
            score = release.at('.disco_avg_rating').text.to_f
            year  = release.at('.disco_subline').text.strip

            ["#{ title } (#{ year })", score]

          }.sort_by { |_t, score| -score }.take(3).map &:first

          message.reply "#{ name } (#{ genres.join ', ' }). Top albums: #{ albums.join ', ' }. #{ page.uri }"
        end
      end
    end
  end
end
