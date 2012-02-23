module GameLogic

  def take_action
    space = feel

    if wounded?
      if space.empty?
        rest!
      else
        attack!
      end
    elsif space.empty?
      walk!
    else
      attack!
    end
  end

end
