class Class
  def inject(*deps)
    check_pinball
    if @dependencies
      @dependencies.concat(deps)
    else
      @dependencies = deps
    end
  end

  def class_inject(*deps)
    deps.each do |dep|
      define_singleton_method dep do
        Pinball::Container.instance.items[dep].fetch(self)
      end
    end
  end

  def check_pinball
    unless self.is_a? Pinball
      self.extend Pinball
    end
  end
end