require 'cinch'
require 'cinch/plugins/identify'

require 'mechanize'

$mechanize_agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

require 'filesize'

require 'miwiki/version'
require 'miwiki/plugins/reporter'
require 'miwiki/plugins/weather'
require 'miwiki/plugins/otaku'

class Numeric
  def relative_occurence
    ago = self > 0
    
    secs  = self.to_int.abs
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    duration =
      if days > 0
        "#{days} days, #{hours % 24} hours"
      elsif hours > 0
        "#{hours} hours, #{mins % 60} minutes"
      elsif mins > 0
        "#{mins} minutes"
      elsif secs >= 0
        "#{secs} seconds"
      end

    if ago
      "#{ duration } ago"
    else
      "in #{ duration }"
    end
  end
end

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
        config.channels = ['#miwiki-test']#, '#cute']

        config.nick     = 'Miwiki'
        config.user     = 'Miwiki'
        config.realname = '高良みゆき'

        config.plugins.prefix = /^\./

        config.plugins.plugins = [
          Cinch::Plugins::Identify,
          Miwiki::Plugins::Reporter,
          Miwiki::Plugins::Weather,
          Miwiki::Plugins::Otaku
        ]
        
        config.plugins.options[Cinch::Plugins::Identify] = {
          :type     => :nickserv,
          :password => '**REMOVED**'
        }
      end
    end.start
  end
end
