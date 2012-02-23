require "#{File.dirname(__FILE__)}/../../spec/game_logic"
require "#{File.dirname(__FILE__)}/../../spec/support/entity_methods"
require "#{File.dirname(__FILE__)}/../../spec/support/warrior_methods"

class Player

  CONAN_LIFE_UNITS=20

  def reapply_methods conan
    conan.extend GameLogic
    conan.extend EntityMethods
    conan.extend WarriorMethods

    def conan.max_health
      CONAN_LIFE_UNITS
    end

    conan.last_health = @health || Player::CONAN_LIFE_UNITS
  end

  def play_turn(warrior)
    reapply_methods warrior

    warrior.take_action

    @health = warrior.health
  end
end
