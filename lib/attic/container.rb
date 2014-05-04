require 'singleton'
require_relative 'container_item'

module Attic
  class Container
    include Singleton

    attr_accessor :items

    def initialize
      @items = {}
    end

    def self.configure(&block)
      self.instance.instance_exec(&block)
    end

    def define(key, value = nil, &block)
      @items[key] = ContainerItem.new(value || block)
    end

    def inject(target)
      target.class.dependencies.each do |dep|
        target.define_singleton_method dep do
          Container.instance.items[dep].fetch(self)
        end
      end
    end
  end
end