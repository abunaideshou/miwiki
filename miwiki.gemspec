# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miwiki/version'

Gem::Specification.new do |spec|
  spec.name          = "miwiki"
  spec.version       = Miwiki::VERSION
  spec.authors       = ["Taylor Sullivan"]
  spec.email         = ["taylor.sullivan@me.com"]

  spec.summary       = %q{An IRC bot built atop cinch.}
  spec.homepage      = "http://github.com/tsul/miwiki"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['miwiki']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'cinch', '~> 2.2.6'
  spec.add_runtime_dependency 'cinch-identify'

  spec.add_runtime_dependency 'mechanize'
  spec.add_runtime_dependency 'filesize'
  spec.add_runtime_dependency 'htmlentities'

  spec.add_runtime_dependency 'geocoder'
  spec.add_runtime_dependency 'ruby-units'
end
