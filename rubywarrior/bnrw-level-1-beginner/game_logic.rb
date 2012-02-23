module GameLogic
  def take_action
    thing = feel

    if thing.empty?
      walk!
    elsif wounded?
      rest!
    else
      attack!
    end
  end
end
