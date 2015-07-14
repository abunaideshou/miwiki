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
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['miwiki']
  spec.require_paths = ['lib']

  if spec.respond_to?(:metadata)
    #spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'cinch', '~> 2.2.6'
  spec.add_runtime_dependency 'cinch-identify'

  spec.add_runtime_dependency 'mechanize'
  spec.add_runtime_dependency 'filesize'
end
