class Class
  def inject(*deps)
    check_atticable
    if @dependencies
      @dependencies.concat(deps)
    else
      @dependencies = deps
    end
  end

  def check_atticable
    unless self.is_a? Attic::Atticable
      self.extend Attic::Atticable
    end
  end
end