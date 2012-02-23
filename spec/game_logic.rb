module GameLogic

  def take_action
    space = feel

    if wounded?
      if space.empty?
        if taking_damage?
          walk!
        else
          rest!
        end
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
