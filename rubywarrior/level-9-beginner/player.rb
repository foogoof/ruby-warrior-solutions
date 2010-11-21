require 'pp'

class Player
  @last_known_health = nil
  RUNAWAY=(20 * 0.40).to_i
  BANZAI=(20 * 0.75).to_i

  VISIBLE_THINGS=%w{ stairs empty wall captive enemy }

  def scan(spaces)
    line_of_sight = {}
    spaces.each_with_index { |space, index|
      distance = index.succ
      entity = VISIBLE_THINGS.select { |type|
        space.send "#{type}?".to_sym
      }.first
      raise "woah" unless entity
      line_of_sight[:nearest] = entity unless line_of_sight[:nearest]
      if line_of_sight[entity]
        line_of_sight[entity] << distance
      else
        line_of_sight[entity] = [distance]
      end
    }

    pp line_of_sight

    line_of_sight
  end

  def play_turn(warrior)
    @last_known_health = warrior.health unless @last_known_health
    took_damage = @last_known_health > warrior.health

    if warrior.feel.wall?
      warrior.pivot!
    elsif warrior.feel.empty?
      i_spy = scan warrior.look(:forward)
      next_good_guy = i_spy.fetch("captive", []).first
      next_bad_guy = i_spy.fetch("enemy", []).first
      if next_good_guy && next_bad_guy
        if next_good_guy < next_bad_guy
          warrior.walk!
        else
          warrior.shoot!
        end
      elsif next_bad_guy
        warrior.shoot!
      elsif took_damage
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
