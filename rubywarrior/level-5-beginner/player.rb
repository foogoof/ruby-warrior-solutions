class Player
  @last_known_health = nil
  def play_turn(warrior)
    @last_known_health = warrior.health unless @last_known_health

    if warrior.feel.empty?
      if warrior.health < @last_known_health
        warrior.walk!
      elsif warrior.health < 12
        warrior.rest!
      else
        warrior.walk!
      end
    else
      warrior.attack!
    end

    @last_known_health = warrior.health
  end
end
