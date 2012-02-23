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
  # attr_accessor :health, :max_health

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
    puts "my max health is #{@max_health}"
  end
end

class Warrior
  include WarriorMethods
end

class Enemy
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
      @enemy = double Enemy

      class << @enemy
        include EntityMethods
      end
      @enemy.health = 5
      @enemy.max_health = 5

      @warrior.feel = @enemy
      p @warrior.feel.max_health, @warrior.feel.health
    end
    
    it "should be hit" do
      p @warrior.feel.health
      @warrior.attack!
      @enemy.should be_wounded
    end
  end

end
