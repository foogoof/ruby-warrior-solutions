class Warrior
end

describe Warrior do
  subject { Player.warrior }

  it { should respond_to(:walk!) }
  it { should respond_to(:attack!) }
  it { should respond_to(:feel) }

  describe "senses" do
    subject { Player.warrior.feel }
    
    it do
      pending "figure out how to reliably grab a space" do
        should respond_to(:empty?)
      end
    end
  end
end
