module GameLogic

  def take_action
    ahead = feel
    behind = feel(:backward)

    if wounded?
      if severely_wounded?
        if behind.empty?
          walk!(:backward)
        end
      else
        if ahead.empty?
          if taking_damage?
            walk!
          else
            rest!
          end
        else
          attack!
        end
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
