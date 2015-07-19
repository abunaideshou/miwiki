module Miwiki
  module Plugins
    class Admin
      include Cinch::Plugin

      match /(\w+)\srestart/i, :use_prefix => false, :method => :restart

      listen_to :notice

      def listen message
        if message.message =~ /^Your vhost/
          bot.config.channels.map { |c| bot.join c }
        end
      end

      def restart message, name
        Kernel.exec 'cd ~/miwiki/ && git pull && rake install && miwiki' if is_me?(name) && should_obey?(message)
      end

      private

      def is_me? name
        name.downcase == bot.nick.downcase
      end

      def should_obey? message
        message.channel.opped? message.user
      end
    end
  end
end
