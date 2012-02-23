module GameLogic
  def take_action
    thing = feel

    if thing.empty?
      walk!
    else
      attack!
    end
  end
end
