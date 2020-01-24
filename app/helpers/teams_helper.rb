# frozen_string_literal: true

module TeamsHelper
  def display_name(team)
    return team.team_name if team.eligible?

    "#{team.team_name} (ineligible)"
  end
end
