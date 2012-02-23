begin
  RSpec::Core::Runner.autorun
rescue
  require 'rspec/core'
  RSpec::Core::Runner.autorun
end

module WarriorMethods
  def walk!
  end

  def attack!
    thing = feel
    p thing
    p thing.health
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
  def wounded?
    @health < @max_health
  end

  def wound
    @health = @health - 1
  end

  def health
    @health
  end

  def health=(new_val)
    @health = new_val
  end

  def max_health
    @max_health
  end

  def max_health=(new_val)
    @max_health = new_val
  end
end

class Warrior
  include WarriorMethods
end

class Enemy
  include EntityMethods
end

describe Warrior do
  before do
    @warrior = Warrior.new
  end

  it { should respond_to(:walk!) }
  it { should respond_to(:attack!) }
  
  describe "senses" do
    it { should respond_to(:feel) }
  end
  
  context "when attacked" do
    before do
      @enemy = Enemy.new
      @enemy.health = @enemy.max_health = 5
      @warrior.feel = @enemy
    end
    
    it "should be hit" do
      @warrior.attack!
      @enemy.should be_wounded
    end
  end

end
