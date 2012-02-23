begin
  RSpec::Core::Runner.autorun
rescue
  require 'rspec/core'
  RSpec::Core::Runner.autorun
end

require "#{File.dirname(__FILE__)}/game_logic"
require "#{File.dirname(__FILE__)}/entity_methods"

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

module TestOnlyMethods
  attr_accessor :health, :max_health

  def rest!
    nap! if health < max_health
  end

  private

  def nap!
    new_health = max_health / 10 + health
    health = [max_health, new_health].min
  end
end


class Warrior
  include WarriorMethods
  include EntityMethods
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
    @warrior = double(Warrior)
    @warrior.extend WarriorMethods
    @warrior.extend EntityMethods
    @warrior.extend TestOnlyMethods
    @warrior.health = @warrior.max_health = 20
  end

  describe Warrior do
    subject { @warrior }
    it { should respond_to(:walk!) }
    it { should respond_to(:attack!) }
    it { should respond_to(:feel) }
    it { should respond_to(:health) }
    it { should respond_to(:rest!) }

    context "resting" do
      context "when at full health" do
        it "should stay at full health" do
          @warrior.should_not_receive(:nap!)
          @warrior.rest!
        end
      end
      context "when wounded" do
        before do
          @warrior.wound
        end
        it "energy should be restored" do
          @warrior.should_receive(:nap!)
          @warrior.rest!
        end

        context GameLogic do
          before do
            @warrior.extend GameLogic
            @warrior.feel = Object.new.extend(EntityMethods)
          end

          it "should rest" do
            @warrior.should_receive(:nap!)
            @warrior.take_action
          end
        end
      end
    end

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
        @enemy = double(Enemy).extend(EntityMethods).extend(TestOnlyMethods)
        @enemy.health = @enemy.max_health = 20
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
