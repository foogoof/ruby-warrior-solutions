require 'rspec/core'; RSpec::Core::Runner.autorun

class Player
  def self.warrior= warrior
    @warrior = warrior
  end
  def self.warrior
    @warrior
  end

  def play_turn(warrior)
    if warrior.feel.empty?
      warrior.walk!
    else
      warrior.attack!
    end
  end
end

require "#{File.dirname(__FILE__)}/warrior"
