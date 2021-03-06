# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pinball/version'

Gem::Specification.new do |spec|
  spec.name          = 'pinball'
  spec.version       = Pinball::VERSION
  spec.authors       = ['Gleb Sinyavsky']
  spec.email         = ['zhulik.gleb@gmail.com']
  spec.summary       = 'Simple dependency injection for ruby'
  spec.description   = 'Simple and stupid IOC container and dependency injection tool for ruby'
  spec.homepage      = 'https://github.com/zhulik/pinball'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = `git ls-files spec`.split($/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6', '> 1.6'
  spec.add_development_dependency 'rake', '~> 10.4'

  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'rspec',  '~> 3.3'
end
