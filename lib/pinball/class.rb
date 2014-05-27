class Class
  def inject(*deps)
    check_pinball
    if @dependencies
      @dependencies.concat(deps).uniq!
    else
      @dependencies = deps
    end
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

      self.send(:define_singleton_method, :inherited) do |child|
        child.instance_variable_set :@dependencies, self.dependencies
        child.check_pinball
      end
    end
  end
end