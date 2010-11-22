require 'pp'

class Player
  @last_known_health = nil
  RUNAWAY=(20 * 0.50).to_i
  BANZAI=(20 * 0.80).to_i

  VISIBLE_THINGS=[ :stairs, :empty, :wall, :captive, :enemy ]
  MAX_RANGED_ATTACK_DISTANCE=3

  def initialize
    @last_shot = nil
    @last_known_health = nil
  end
  
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
    shot = nil

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

      sneaky_captive = i_spy[:backward][:captive] && i_spy[:backward][:view].all? {|item| [:empty, :stairs, :wall, :captive].include? item }
      
      nearest_wall = i_spy[:backward].fetch(:nearest_wall, MAX_RANGED_ATTACK_DISTANCE + 1)
      nearest_enemy = i_spy[:forward][:nearest_enemy]
      nearest_captive = i_spy[:forward][:nearest_captive]

      nowhere_to_run = false
      if nearest_wall && nearest_enemy && took_damage
        nowhere_to_run = (nearest_enemy + (nearest_wall - 1)) <= MAX_RANGED_ATTACK_DISTANCE
      end

      #pp i_spy
      #puts stairs_ahead, stairs_behind, sneaky_captive, nearest_captive, nearest_wall, nearest_enemy, nowhere_to_run

      if stairs_ahead
        warrior.walk! :forward
      elsif stairs_behind || sneaky_captive
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
        surrounded = [:backward, :forward].all? { |dir| i_spy[dir][:enemy] } # it's a trap!!
        
        if surrounded && i_spy[:backward][:nearest_enemy] < i_spy[:forward][:nearest_enemy]
          warrior.pivot!
        elsif @last_shot
          if nearest_enemy == @last_shot # @#!$#@ didn't die, charge!!
            warrior.walk!
          elsif nearest_enemy
            warrior.shoot!
            shot = nearest_enemy
          else
            warrior.walk!
          end
        elsif nearest_enemy || nearest_captive
          if nearest_enemy == [nearest_enemy, nearest_captive].compact.min
            warrior.shoot!
            shot = nearest_enemy
          else
            warrior.walk!
          end
        else
          warrior.walk!
        end
      end
    end

    @last_known_health = warrior.health
    @last_shot = shot
  end
end
