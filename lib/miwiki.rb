require 'cinch'
require 'cinch/plugins/identify'
require 'filesize'
require 'mechanize'

$mechanize_agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

require 'patches'

require 'miwiki/version'
require 'miwiki/plugins/inspector'
require 'miwiki/plugins/weather'
require 'miwiki/plugins/otaku'
require 'miwiki/plugins/lastfm'
require 'miwiki/plugins/booru'
require 'miwiki/plugins/rym'
require 'miwiki/plugins/youtube'

module Miwiki
  def self.start
    Cinch::Bot.new do
      configure do |config|
        config.server   = 'irc.rizon.net'
        config.channels = ['#miwiki-test', '#cute']

        config.nick     = 'Miwiki'
        config.user     = 'Miwiki'
        config.realname = '高良みゆき'

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
          :password => '**REMOVED**'
        }

        config.plugins.options[Cinch::Plugins::Otaku] = {
          :user     => 'rallizes',
          :password => '**REMOVED**'
        }

        config.plugins.options[Cinch::Plugins::Booru] = {
          :login   => 'miwiki-bot',
          :api_key => 'e9VwzTgtJ_7YRSaxNvjTPanwG18zn_fK_oJqiIX_tfE'
        }
      end
    end.start
  end
end
