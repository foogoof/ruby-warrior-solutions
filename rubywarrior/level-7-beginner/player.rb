class Player
  @last_known_health = nil
  RUNAWAY=20 * 0.40
  BANZAI=20 * 0.75
  
  # screw the captive! muahahah!
  def play_turn(warrior)
    @last_known_health = warrior.health unless @last_known_health
    took_damage = @last_known_health > warrior.health

    if warrior.feel.empty?
      if took_damage
        if warrior.health <= RUNAWAY
          warrior.walk! :backward
        else
          warrior.walk! :forward
        end
      else
        if warrior.health < BANZAI
          warrior.rest!
        else
          warrior.walk! :forward
        end
      end
    else
      if warrior.feel.captive?
        warrior.rescue!
      else
        warrior.attack!
      end
    end

    @last_known_health = warrior.health
  end
end
