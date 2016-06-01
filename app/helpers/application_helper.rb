module ApplicationHelper
  def is_team_captain
    if !current_user.nil? and current_user.on_a_team? and current_user == current_user.team.team_captain
      return true
    else
      return false
    end
  end
end
