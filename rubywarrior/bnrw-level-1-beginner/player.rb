require "#{File.dirname(__FILE__)}/../../spec/game_logic"
require "#{File.dirname(__FILE__)}/../../spec/entity_methods"

class Player

  def self.gross_hack_data_setup conan
    def conan.max_health
      20
    end
  end

  def play_turn(warrior)
    warrior.extend GameLogic
    warrior.extend EntityMethods

    Player.gross_hack_data_setup warrior

    warrior.take_action
  end
end
