require 'rspec/core'; RSpec::Core::Runner.autorun
require "#{File.dirname(__FILE__)}/game_logic"

class Player
  def play_turn(warrior)
    warrior.extend GameLogic
    warrior.take_action
  end
end
