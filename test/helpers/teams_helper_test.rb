require 'test_helper'

class TeamsHelperTest < ActionView::TestCase

  def setup
    @game = create(:active_game, prizes_available: true)
  end

  test 'display name ineligible' do
    team = create(:team)
    assert_includes display_name(team), '(ineligible)'
  end

  test 'display name does not include ineligible when no prizes are available' do
    @game.update(prizes_available: false)
    team = create(:team)
    assert_equal team.team_name, display_name(team)
  end

  test 'display name eligible' do
    team = create(:team)
    team.team_captain.update(compete_for_prizes: true)
    team.reload
    assert_equal team.team_name, display_name(team)
  end

  test 'eligible' do
    request = create(:point_user_request)

    assert_equal I18n.t('teams.show.ineligible'), eligible?(request)

    request = create(:point_user_request, user: create(:user, compete_for_prizes: true))
    assert_equal I18n.t('teams.show.eligible'), eligible?(request)
  end

  test 'solved challenge table point value' do
    team = create(:team)
    solved_challenge = create(:standard_solved_challenge, team: team)
    assert_equal solved_challenge.challenge.display_point_value, solved_challenge_table_point_value(solved_challenge, team)

    team = create(:team)
    solved_challenge = create(:pentest_solved_challenge, team: team)
    assert_equal solved_challenge.flag.display_point_value(team), solved_challenge_table_point_value(solved_challenge, team)
  end

  test 'header with points' do
    team = create(:team)
    assert_includes header_with_points(team), team.team_name
    assert_includes header_with_points(team), team.score.to_s

    Game.first.destroy
    game = create(:active_game)
    team = create(:team)
    assert_includes header_with_points(team), team.team_name
    assert_includes header_with_points(team), team.score.to_s
  end
end
