# encoding: UTF-8
version = "1.1.0.beta"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_refinery_auth'
  s.version     = version
  s.summary     = 'Provides overrides to make both Spree and Refinery auth work together.'
  s.description = "It is some monkey patching, but still work. It has not been tested enough to assume it'll work in your application"
  s.required_ruby_version = '>= 1.8.7'

  s.author      = 'Jean-Philippe Boily'
  s.email       = 'j@jipi.ca'
  s.homepage    = 'https://github.com/jipiboily/spree_refinery_auth'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.files        = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*']

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', version

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'sqlite3'
end
