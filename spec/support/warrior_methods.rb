module WarriorMethods

  attr_accessor :last_health
  attr_accessor :ahead, :behind
  
  def walk!
  end

  def attack!
    thing = feel
    thing.wound
  end

  def severely_wounded?
    health <= max_health / 10
  end

  def feel(direction = :forward)
    case direction
    when :forward
      ahead
    when :backward
      behind
    else
      raise "Unexpected direction #{direction}"
    end
  end

end
