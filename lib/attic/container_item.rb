module Attic
  class ContainerItem
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def fetch(target)
      if value.is_a? Proc
        target.instance_eval(&value)
      elsif value.is_a? Module #Class definition
        value.new
      else
        value
      end
    end
  end
end