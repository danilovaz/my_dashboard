# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_dashboard/version'

Gem::Specification.new do |spec|
  spec.name         = 'my_dashboard'
  spec.version      = MyDashboard::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors      = ['Danilo Vaz']
  spec.email        = ['danilo.vaz@mlabs.com.br']
  spec.description  = 'Generate awesome widgets dashboard for Rails with FlexBox.'
  spec.summary      = 'Generate awesome widgets dasboard for Rails with FlexBox.'
  spec.homepage     = 'https://github.com/danilovaz/my_dashboard'
  spec.license      = 'MIT'

  spec.files        = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails',                       '~> 4.0'
  spec.add_dependency 'jquery-rails',            '~> 3.0'
  spec.add_dependency 'coffee-script',          '~> 2.0'
  spec.add_dependency 'rufus-scheduler',     '~> 3.2'
  spec.add_dependency 'redis',                      '~> 3.2'
  spec.add_dependency 'connection_pool',    '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 1.12.4'
  spec.add_development_dependency 'pry-rails', '~> 0.3.4'
  spec.add_development_dependency 'better_errors', '~> 2.1.1'
end
