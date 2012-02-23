begin
  RSpec::Core::Runner.autorun
rescue
  require 'rspec/core'
  RSpec::Core::Runner.autorun
end

require "#{File.dirname(__FILE__)}/game_logic"

module WarriorMethods
  def walk!
  end

  def attack!
    thing = feel
    thing.wound
  end

  def feel
    @thing
  end

  def feel=(thing)
    @thing = thing
  end
end

module EntityMethods
  attr_accessor :health, :max_health

  def wounded?
    @health < @max_health
  end

  def wound
    @health = @health - 1
  end

  def empty?
    false
  end
end

class Warrior
  include WarriorMethods
end

class Enemy
  include EntityMethods
end

class Space
  def empty?
    true
  end
end

describe "RubyWarrior" do
  before do
    @warrior = double(Warrior).extend WarriorMethods
  end

  describe Warrior do
    it { should respond_to(:walk!) }
    it { should respond_to(:attack!) }
    it { should respond_to(:feel) }

    context "when facing nothing" do
      before do
        @space = double(Space).extend EntityMethods
        @space.stub(:empty?) { true }
        @warrior.feel = @space
      end

      it "should walk" do
        if @warrior.feel.empty?
          @warrior.walk!
        end
      end

      context GameLogic do
        before do
          @warrior.extend GameLogic
        end

        it "should walk" do
          @warrior.should_receive :walk!
          @warrior.take_action
        end
      end
    end

    context "when facing an enemy" do
      before do
        @enemy = double(Enemy).extend EntityMethods
        @enemy.health = @enemy.max_health = 5
        @warrior.feel = @enemy
      end
      
      it "should be attacked" do
        @enemy.should_not be_wounded
        @warrior.attack!
        @enemy.should be_wounded
      end

      context GameLogic do
        before do
          @warrior.extend GameLogic
        end

        it "should be attacked" do
          @enemy.should_not be_wounded
          @warrior.take_action
          @enemy.should be_wounded
        end
      end
    end
  end

end
