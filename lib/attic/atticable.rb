require_relative 'container'

module Attic
  module Atticable

    def new(*args)
      object = allocate
      Container.instance.inject(object)
      object.send(:initialize, *args)
      object
    end

    def dependencies
      @dependencies
    end
  end
end