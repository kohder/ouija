# encoding: utf-8
require File.expand_path('lib/ouija/version')

Gem::Specification.new do |gem|
  gem.name          = 'ouija'
  gem.version       = Ouija::Version.current
  gem.platform      = Gem::Platform::RUBY
  gem.author        = 'Rob Lewis (kohder)'
  gem.email         = 'rob@kohder.com'
  gem.homepage      = 'http://github.com/kohder/ouija'
  gem.description   = 'The Ouija configuration gem'
  gem.summary       = 'Hold a séance and listen to what your configuration is trying to tell you.  Fun for the whole family.'
  gem.license       = 'MIT'

  gem.required_ruby_version = '>= 1.9.2'

  #gem.files         = %x[git ls-files].split("\n")
  gem.files         = %w{ouija.gemspec LICENSE.md lib/ouija.rb lib/ouija/ouija.rb lib/ouija/planchette.rb lib/ouija/version.rb lib/ouija/medium/yaml.rb}
  #gem.test_files    = %x[git ls-files -- {spec}/*].split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = %w(lib)
end
