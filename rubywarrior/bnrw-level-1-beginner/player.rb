require 'rspec/core'
RSpec::Core::Runner.autorun

class Player
  def self.warrior= warrior
    @warrior ||= warrior
  end
  def self.warrior
    @warrior
  end

  def play_turn(warrior)
    Player.warrior = warrior
    warrior.walk!
  end
end

require "#{File.dirname(__FILE__)}/warrior"
