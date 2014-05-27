require 'singleton'
require_relative 'container_item'

module Pinball
  class Container
    include Singleton

    attr_reader :items

    class << self
      def configure(&block)
        self.instance.instance_exec(&block)
      end

      def lookup(key)
        Pinball::Container.instance.items[key]
      end

      def clear
        Pinball::Container.instance.items.clear
      end

      def define(key, value = nil, &block)
        Pinball::Container.instance.define(key, value, &block)
      end

      def undefine(key)
        Pinball::Container.instance.undefine(key)
      end
    end

    def initialize

      @items = {}
    end

    def define(key, value = nil, &block)
      @items[key] = ContainerItem.new(value || block)
    end

    def undefine(key)
      @items.delete(key)
    end

    def inject(target)
      target.class.dependencies.each do |dep|
        target.define_singleton_method dep do
          Container.instance.items.merge(overridden_dependencies)[dep].fetch(self)
        end
      end
    end
  end
end