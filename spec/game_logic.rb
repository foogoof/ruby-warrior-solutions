module GameLogic

  def take_action
    ahead = feel
    behind = feel(:backward)

    if wounded?
      if ahead.empty?
        if taking_damage?
          walk!
        else
          rest!
        end
      else
        attack!
      end
    elsif ahead.captive?
      self.rescue!
    elsif ahead.empty?
      walk!
    else
      attack!
    end
  end

end
