# Base IRC stuff
require 'cinch'
require 'cinch/plugins/identify'

# Helpful runtime libraries
require 'filesize'
require 'mechanize'
require 'htmlentities'

# Static Mechanize agent to handle most of our web lookups
$mechanize_agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

# Utility monkey patches
require 'patches'

require 'miwiki/version'
require 'miwiki/config'

require 'miwiki/plugins/inspector'
require 'miwiki/plugins/weather'
require 'miwiki/plugins/otaku'
require 'miwiki/plugins/lastfm'
require 'miwiki/plugins/booru'
require 'miwiki/plugins/rym'
require 'miwiki/plugins/youtube'

module Miwiki
  def self.start
    cinch_config   = Miwiki::config[:cinch]
    plugins_config = Miwiki::config[:plugins]

    Cinch::Bot.new do
      configure do |config|
        config.server   = cinch_config[:server]
        config.channels = cinch_config[:channels]

        config.nick     = cinch_config[:nick]
        config.user     = cinch_config[:user]
        config.realname = cinch_config[:realname]

        config.plugins.prefix = /^\./

        config.plugins.plugins = [
          Cinch::Plugins::Identify,
          Miwiki::Plugins::Inspector,
          Miwiki::Plugins::Weather,
          Miwiki::Plugins::Otaku,
          Miwiki::Plugins::LastFM,
          Miwiki::Plugins::Booru,
          Miwiki::Plugins::RYM,
          Miwiki::Plugins::YouTube
        ]
        
        config.plugins.options[Cinch::Plugins::Identify] = {
          :type     => :nickserv,
          :password => plugins_config[:identify][:password]
        }

        config.plugins.options[Miwiki::Plugins::Otaku] = {
          :user     => plugins_config[:otaku][:mal_user],
          :password => plugins_config[:otaku][:mall_password]
        }

        config.plugins.options[Miwiki::Plugins::Booru] = {
          :login   => plugins_config[:booru][:safebooru_user],
          :api_key => plugins_config[:booru][:safebooru_api_key]
        }
      end
    end.start
  end
end
