class Class
  def inject(*deps)
    check_pinball
    @dependencies ||= []
    @dependencies.concat(deps).uniq!
  end

  def class_inject(*deps)
    deps.each do |dep|
      define_singleton_method dep do
        Pinball::Container.lookup(dep).fetch(self)
      end
    end
  end

  def check_pinball
    unless is_a? Pinball
      extend Pinball
      public_send(:include, Pinball::Methods)

      public_send(:define_singleton_method, :inherited_with_pinball) do |child|
        inherited_without_pinball(child) if respond_to?(:inherited_without_pinball)
        child.instance_variable_set :@dependencies, dependencies
        child.check_pinball
      end

      public_send(:define_singleton_method, :inherited_without_pinball, method(:inherited)) if respond_to?(:inherited)
      public_send(:define_singleton_method, :inherited, method(:inherited_with_pinball))
    end
  end
end