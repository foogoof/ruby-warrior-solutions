module GameLogic

  def take_action
    ahead = feel
    behind = feel(:backward)
    action, args = nil, nil

    if wounded?
      if severely_wounded?
        if behind.empty?
          if taking_damage?
            action = :walk!
            args = :backward
          else
            action = :rest!
          end
        elsif behind.captive?
          action = :rescue!
          args = :backward
        else
          action = :rest!
        end
      else
        if ahead.empty?
          if taking_damage?
            action = :walk!
          else
            action = :rest!
          end
        else
          action = :attack!
        end
      end
    elsif ahead.wall?
      action = :pivot!
    elsif ahead.captive?
      action = :rescue!
    elsif ahead.empty?
      if can_see_enemy?
        action = :shoot!
      else
        action = :walk!
      end
    else
      action = :attack!
    end

    raise "uh, you forgot to do something" unless action
    if args
      send action, args
    else
      send action
    end
  end

end
