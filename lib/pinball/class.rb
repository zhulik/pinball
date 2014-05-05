class Class
  def inject(*deps)
    check_pinball
    if @dependencies
      @dependencies.concat(deps)
    else
      @dependencies = deps
    end
  end

  def check_pinball
    unless self.is_a? Pinball
      self.extend Pinball
    end
  end
end