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
  spec.description   = 'Simple dependency injection for ruby'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = []
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec',  '~> 2.14.1'
end
