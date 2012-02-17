class Warrior
end

describe Warrior do
  subject { Player.warrior }
  it { should respond_to(:walk!) }
end
