# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attic/version'

Gem::Specification.new do |spec|
  spec.name          = 'attic'
  spec.version       = Attic::VERSION
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

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
