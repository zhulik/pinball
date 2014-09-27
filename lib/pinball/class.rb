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
    unless self.is_a? Pinball
      self.extend Pinball
      self.send(:include, Pinball::Methods)

      self.send(:define_singleton_method, :inherited_with_pinball) do |child|
        inherited_without_pinball(child) if respond_to?(:inherited_without_pinball)
        child.instance_variable_set :@dependencies, self.dependencies
        child.check_pinball
      end

      self.send(:define_singleton_method, :inherited_without_pinball, self.method(:inherited)) if self.respond_to?(:inherited)
      self.send(:define_singleton_method, :inherited, self.method(:inherited_with_pinball))
    end
  end
end