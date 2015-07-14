require 'cinch'
require 'cinch/plugins/identify'

require 'mechanize'

$mechanize_agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

require 'filesize'

require 'miwiki/version'
require 'miwiki/plugins/reporter'

class String
  def truncate max_length=140
    if length > max_length
      self[0..(max_length - 3)] + '...'
    else
      dup
    end
  end
end

module Miwiki
  def self.start
    Cinch::Bot.new do
      configure do |config|
        config.server   = 'irc.rizon.net'
        config.channels = ['#miwiki-test', '#cute']

        config.nick     = 'Miwiki'
        config.user     = 'Miwiki'
        config.realname = '高良みゆき'

        config.plugins.plugins = [
          Cinch::Plugins::Identify,
          Miwiki::Plugins::Reporter
        ]
        
        config.plugins.options[Cinch::Plugins::Identify] = {
          :type     => :nickserv,
          :password => '**REMOVED**'
        }
      end
    end.start
  end
end
