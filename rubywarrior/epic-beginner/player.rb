require 'pp'

class Player
  @last_known_health = nil
  RUNAWAY=(20 * 0.60).to_i
  BANZAI=(20 * 0.80).to_i

  VISIBLE_THINGS=[ :stairs, :empty, :wall, :captive, :enemy ]
  MAX_RANGED_ATTACK_DISTANCE=3

  def scan(spaces)
    line_of_sight = {}

    spaces.each_with_index { |space, index|
      distance = index.succ
      entity = VISIBLE_THINGS.select { |type|
        space.send "#{type.to_s}?".to_sym
      }.first
      raise "woah" unless entity
      line_of_sight[:nearest] = entity unless line_of_sight[:nearest]
      if line_of_sight[entity]
        line_of_sight[entity] << distance
      else
        line_of_sight[entity] = [distance]
      end

      nearest_entity_key = "nearest_#{entity.to_s}".to_sym
      line_of_sight[nearest_entity_key] = distance unless line_of_sight[nearest_entity_key]

      # zero based distance could be easy to forget...
      if line_of_sight[:view]
        line_of_sight[:view] << entity
      else
        line_of_sight[:view] = [entity]
      end
    }

    line_of_sight
  end

  def play_turn(warrior)
    @last_known_health = warrior.health unless @last_known_health
    took_damage = @last_known_health > warrior.health

    if warrior.feel.wall?
      warrior.pivot!
    elsif warrior.feel.enemy?
      warrior.attack!
    elsif warrior.feel.captive?
      warrior.rescue!
    else
      i_spy = [:backward, :forward].reduce({}) { |area, direction|
        area[direction] = scan warrior.look(direction)
        area
      }

      stairs_ahead, stairs_behind = [:forward, :backward].map { |dir|
        next false unless i_spy[dir][:stairs]
        i_spy[dir][:view].all? { |item| [:empty, :stairs, :wall].include? item }
      }

      closest_wall = i_spy[:backward].fetch(:nearest_wall, MAX_RANGED_ATTACK_DISTANCE + 1)
      closest_enemy = i_spy[:forward][:nearest_enemy]

      if !(closest_wall && closest_enemy && took_damage)
        nowhere_to_run = false
      else
        nowhere_to_run = (closest_enemy + (closest_wall - 1)) <= MAX_RANGED_ATTACK_DISTANCE
      end
      
      if stairs_ahead
        warrior.walk! :forward
      elsif stairs_behind
        warrior.pivot!
      elsif took_damage
        if warrior.health > RUNAWAY || nowhere_to_run
          warrior.walk! :forward
        else
          warrior.walk! :backward
        end
      elsif warrior.health < BANZAI
        warrior.rest!
      else
        if [:backward, :forward].all? { |dir| i_spy[dir][:enemy] } # it's a trap!!
          if i_spy[:backward][:nearest_enemy] > i_spy[:forward][:nearest_enemy]
            warrior.pivot!
          else
            warrior.walk!
          end
        else
          warrior.walk!
        end
      end
    end
    @last_known_health = warrior.health
  end
end
