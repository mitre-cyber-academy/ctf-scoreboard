# frozen_string_literal: true

module TeamsHelper
  def display_name(team)
    return team.team_name if team.eligible?

    "#{team.team_name} (ineligible)"
  end

  def solved_challenge_table_point_value(solved_challenge, team)
    if solved_challenge.is_a?(PentestSolvedChallenge)
      solved_challenge.flag.point_value(team)
    else
      solved_challenge.challenge.point_value
    end
  end

  def eligible?(user_request)
    return t('teams.show.eligible') if user_request.user.compete_for_prizes

    t('teams.show.ineligible')
  end

  def header_with_points(team)
    "#{display_name(team)} - #{team.score} points"
  end
end
