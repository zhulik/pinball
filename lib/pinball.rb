require 'pinball/version'
require 'pinball/container'
require 'pinball/class'

module Pinball
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