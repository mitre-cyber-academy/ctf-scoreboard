# frozen_string_literal: true

module GamesHelper
  def table_subtitle(game, challenges, headings)
    noun = team_or_category(game)
    "#{pluralize(challenges.size, 'challenge')} across #{pluralize(headings.size, noun)}"
  end

  def team_or_category(game)
    return 'team' if game.is_a?(PentestGame)

    'category'
  end

  def heading_width(headings)
    1.0 / headings.size.to_f * 100.0
  end

  def cell_background_color(team)
    return '' unless team.eql? current_user&.team&.team_name

    'background-color: #F0F0F0;'
  end

  def challenge_color(challenge, defense_team)
   return 'color:#999999;' if own_team_challenge?(defense_team)
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

  def own_team_challenge?(defense_team)
    defense_team&.eql?(current_user&.team)
  end

  def get_team_by_name(teams, team_name)
    team = teams.select { |team| team.team_name.eql? team_name }
    team.first.id
  end
end
