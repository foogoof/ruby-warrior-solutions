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
    health <= max_health / 2
  end

  def next_thing
    look.find { |thing| !thing.empty? }
  end

  # def look
  #   []
  # end

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
