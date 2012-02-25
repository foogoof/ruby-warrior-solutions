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
    elsif space.captive?
      self.rescue!
    elsif space.empty?
      walk!
    else
      attack!
    end
  end

end
