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

