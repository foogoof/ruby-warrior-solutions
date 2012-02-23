require "spec_helper"

class Warrior
  include WarriorMethods
  include EntityMethods
end

class Enemy
  include EntityMethods
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

    context "when wounded and not alone" do
      before do
        @warrior.wound
        @warrior.extend GameLogic
        @warrior.feel = Object.new.extend(EntityMethods).extend(TestOnlyMethods)
        @warrior.feel.health = 5
      end
      
      it "should attack instead of resting" do
        @warrior.should_receive(:attack!)
        @warrior.should_not_receive(:nap!)
        @warrior.take_action
      end
    end

    context "when facing nothing" do
      before do
        @space = double(Object).extend EntityMethods
        @space.stub(:empty?) { true }
        @warrior.feel = @space
        @warrior.extend GameLogic
      end

      it "should walk" do
        @warrior.should_receive :walk!
        @warrior.take_action
      end
    end

    context "when facing an enemy" do
      before do
        @enemy = double(Enemy).extend(EntityMethods).extend(TestOnlyMethods)
        @enemy.health = @enemy.max_health = 20
        @warrior.feel = @enemy
        @warrior.extend GameLogic
      end

      it "have at it!" do
        @enemy.should_not be_wounded
        @warrior.take_action
        @enemy.should be_wounded
      end
    end
  end

end
