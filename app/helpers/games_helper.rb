# frozen_string_literal: true

module GamesHelper
  def heading_width(headings)
    1.0 / headings.size.to_f * 100.0
  end

  def cell_background_color(team)
    return '' unless team.eql? current_user&.team

    'background-color: #F0F0F0;'
  end

  def challenge_color(challenge, defense_team = nil)
    return 'color:#999999;' if own_team_challenge?(defense_team)

    challenge_color_for_other_team(challenge)
  end

  # rubocop:disable Metrics/MethodLength
  def challenge_color_for_other_team(challenge)
    if challenge.force_closed?
      'color:#800000;'
    elsif challenge.get_solved_challenge_for(current_user&.team)
      'color:#00abca;'
    elsif challenge.solved?(2)
      'color:#00cc00;'
    elsif challenge.solved?(1)
      'color:#009900;'
    elsif challenge.open?
      'color:#006600;'
    else
      'color:#999999;'
    end
  end
  # rubocop:enable Metrics/MethodLength

  def own_team_challenge?(defense_team)
    defense_team&.eql?(current_user&.team)
  end
end
