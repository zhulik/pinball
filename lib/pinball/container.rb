require 'singleton'
require_relative 'container_item'

module Pinball
  class Container
    include Singleton

    attr_reader :items

    class << self
      def configure(&block)
        instance.instance_exec(&block)
      end

      def lookup(key)
        instance.items[key]
      end

      def clear
        instance.items.clear
      end

      def define(key, value = nil, &block)
        instance.define(key, value, &block)
      end

      def define_singleton(key, klass)
        instance.define_singleton(key, klass)
      end

      def undefine(key)
        instance.undefine(key)
      end
    end

    def initialize
      @items = {}
    end

    def define(key, value = nil, &block)
      @items[key] = ContainerItem.new(value || block)
    end

    def define_singleton(key, klass)
      if klass.instance_method(:initialize).arity <= 0
        @items[key] = ContainerItem.new(klass.new)
      else
        raise Pinball::WrongArity.new('Singleton dependency initializer should not have mandatory params')
      end
    end

    def undefine(key)
      @items.delete(key)
    end

    def inject(target)
      target.class.dependencies.each do |dep|
        unless target.respond_to?(dep)
          target.define_singleton_method dep do
            begin
              Container.instance.items.merge(overridden_dependencies)[dep].fetch(self)
            rescue NoMethodError
              raise Pinball::UnknownDependency.new("Dependency #{dep} is unknown, check your pinball config")
            end
          end
        end
      end

    end
  end
end