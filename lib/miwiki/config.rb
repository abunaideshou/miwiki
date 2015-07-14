# Borrowed liberally from StackOverflow user Nicholas B.
# http://stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem

require 'yaml'

module Miwiki
  @config = :cinch => {
              :server   => 'irc.rizon.net',
              :channels => [],
              :nick     => 'Miwiki',
              :user     => 'Miwiki',
              :realname => 'Takara Miyuki'
            },
            :plugins => {
              :identify => {
                :password => 'abcd1234'
              },
              :otaku => {
                :mal_user     => 'animefan420',
                :mal_password => 'abcd1234'
              },
              :booru => {
                :safebooru_user    => 'animefan420',
                :safebooru_api_key => 'abcd1234'
              }
            }

  @valid_config_keys = @config.keys

  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end
end
