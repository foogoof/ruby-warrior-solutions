module WarriorMethods
  def walk!
  end

  def attack!
    thing = feel
    thing.wound
  end

  def feel
    @thing
  end

  def feel=(thing)
    @thing = thing
  end
end
