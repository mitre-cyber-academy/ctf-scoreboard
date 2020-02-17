# frozen_string_literal: true

module TeamsHelper
  def display_name(team)
    return team.team_name if team.eligible?

    "#{team.team_name} (ineligible)"
  end

  def category_header(game)
    return 'Defense Team' if game.is_a?(PentestGame)

    'Category'
  end

  def solved_challenge_title(game, solved_challenge)
    if game.is_a?(PentestGame)
      if solved_challenge.challenge.design_phase
        'Design Phase'
      else
        solved_challenge.flag.team.team_name
      end
    else
      solved_challenge.challenge.category.name
    end
  end

  def solved_challenge_table_point_value(game, solved_challenge, team)
    if game.is_a?(PentestGame)
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
