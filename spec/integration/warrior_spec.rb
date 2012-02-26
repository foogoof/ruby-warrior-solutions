require "spec_helper"

def make_space
  double(Object).extend(EntityMethods).tap do |space|
    space.stub(:empty?) { true }
  end
end

def make_wall
  double(Object).extend(EntityMethods).tap do |wall|
    wall.stub(:wall?) { true }
  end
end

def make_enemy
  double(Object).extend(EntityMethods).tap do |enemy|
    enemy.stub(:enemy?) { true }
  end
end

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
    @warrior.extend GameLogic

    @warrior.health = @warrior.max_health = @warrior.last_health = 20
  end

  describe Warrior do
    subject { @warrior }

    context "when an enemy is visible" do
      before do
        ahead = [make_space, make_enemy, make_space]
        @warrior.stub(:look) { ahead }
        @warrior.stub(:ahead) { ahead.first }
        @warrior.stub(:behind) { make_space }
      end
      it "should shoot" do
        @warrior.should_receive(:shoot!)
        @warrior.take_action
      end
    end

    context "when facing a wall" do
      before do
        @warrior.behind = make_space
        @warrior.ahead = make_wall
      end

      it "should pivot" do
        @warrior.should_receive(:pivot!)
        @warrior.take_action
      end
    end

    context "when heavily wounded" do
      before do
        @warrior.ahead = make_space
        @warrior.behind = make_space
      end

      it "should retreat" do
        # HOW: to support multiple calls to feel with different args?
        # @warrior.should_receive(:feel).with(:backward)

        @warrior.should_receive(:walk!).with(:backward)

        # WHY: state changes don't stick... have to replace method calls with stubs
        # @warrior.nearly_slay!
        @warrior.stub(:health) { @warrior.max_health / 10 }

        @warrior.take_action
      end

    end

    context "when lightly wounded" do
      before do
        @warrior.wound
      end

      context "and taking damage" do
        before do
          @warrior.ahead = make_space
        end

        it "should charge into danger" do
          @warrior.should_receive :walk!
          @warrior.take_action
        end
      end

      context "and not alone" do
        before do
          @warrior.ahead = Object.new.extend(EntityMethods).extend(TestOnlyMethods)
          @warrior.feel.health = 5
        end

        it "should attack instead of resting" do
          @warrior.should_receive(:attack!)
          @warrior.should_not_receive(:nap!)
          @warrior.take_action
        end
      end
    end

    context "when facing nothing" do
      before do
        @warrior.ahead = make_space
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
        @warrior.ahead = @enemy
      end

      it "have at it!" do
        @enemy.should_not be_wounded
        @warrior.take_action
        @enemy.should be_wounded
      end
    end
  end

end
