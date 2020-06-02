# frozen_string_literal: true

module GamesHelper
  def heading_width(headings)
    1.0 / headings.size.to_f * 100.0
  end

  def cell_background_color(team)
    return '' unless team.eql? current_user&.team

    'background-color: #F0F0F0;'
  end

  def challenge_colors(challenge, defense_team = nil)
    return %w[inherit inherit] unless challenge.respond_to?('open?')
    return ['#999999', '#000'] if own_team_challenge?(defense_team)

    challenge_color_for_other_team(challenge)
  end

  def challenge_text_for_team_for(challenge, team)
    if current_user&.team.eql?(team) && challenge.open? && challenge.can_be_solved_by(team)
      'Click to Solve'
    elsif !challenge.can_be_solved_by(team)
      'Solved'
    else
      '-'
    end
  end

  # rubocop:disable Metrics/MethodLength
  def challenge_color_for_other_team(challenge)
    if challenge.force_closed?
      ['#800000', '#eee']
    elsif challenge.get_solved_challenge_for(current_user&.team)
      ['#00abca', '#eee']
    elsif challenge.solved?(2)
      ['#00cc00', '#444']
    elsif challenge.solved?(1)
      ['#009900', '#eee']
    elsif challenge.open?
      ['#006600', '#fff']
    else
      ['#999999', '#eee']
    end
  end
  # rubocop:enable Metrics/MethodLength

  def own_team_challenge?(defense_team)
    defense_team&.eql?(current_user&.team)
  end
end
