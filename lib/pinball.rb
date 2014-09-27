require 'pinball/version'
require 'pinball/container'
require 'pinball/class'

module Pinball
  module Methods
    attr_reader :overridden_dependencies

    def override_dependency(key, value = nil, &block)
      @overridden_dependencies[key] = ContainerItem.new(value || block)
      Container.instance.inject(self)
      self
    end
  end

  class UnknownDependency < StandardError
  end

  class WrongArity < StandardError
  end

  attr_reader :dependencies

  def new(*args)
    object = allocate
    Container.instance.inject(object)
    object.instance_variable_set(:@overridden_dependencies, {})
    object.send(:initialize, *args)
    object
  end
end