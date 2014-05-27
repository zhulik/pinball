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

  private

  def check_pinball
    unless self.is_a? Pinball
      self.extend Pinball
      self.send(:include, Pinball::Methods)
    end
  end
end