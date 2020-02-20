require 'test_helper'

class TeamsHelperTest < ActionView::TestCase

  def setup
    @game = create(:active_point_game)
  end

  test 'display name ineligible' do
    team = create(:point_team)
    assert_includes display_name(team), '(ineligible)'
  end

  test 'display name eligible' do
    team = create(:point_team)
    team.team_captain.update(compete_for_prizes: true)
    team.reload
    assert_equal team.team_name, display_name(team)
  end

  test 'category header' do
    assert_equal 'Category', category_header(@game)

    Game.first.destroy

    game = create(:active_pentest_game)

    assert_equal 'Defense Team', category_header(game)
  end

  test 'solved challenge title' do
    team = create(:point_team)
    solved_challenge = create(:point_solved_challenge, team: team)
    assert_equal solved_challenge.challenge.category.name, solved_challenge_title(@game, solved_challenge)

    Game.first.destroy
    game = create(:active_pentest_game)
    team = create(:pentest_team)
    solved_challenge = create(:pentest_solved_challenge, team: team)
    assert_equal solved_challenge.flag.team.team_name, solved_challenge_title(game, solved_challenge)

    challenge = create(:design_phase_pentest_challenge_with_flag)
    solved_challenge = create(:pentest_solved_challenge, team: team, challenge: challenge)
    assert_equal 'Design Phase', solved_challenge_title(game, solved_challenge)
  end

  test 'eligible' do
    request = create(:point_user_request)

    assert_equal I18n.t('teams.show.ineligible'), eligible?(request)

    request = create(:point_user_request, user: create(:user, compete_for_prizes: true))
    assert_equal I18n.t('teams.show.eligible'), eligible?(request)
  end

  test 'solved challenge table point value' do
    team = create(:point_team)
    solved_challenge = create(:point_solved_challenge, team: team)
    assert_equal solved_challenge.challenge.point_value, solved_challenge_table_point_value(@game, solved_challenge, team)

    Game.first.destroy
    game = create(:active_pentest_game)
    team = create(:pentest_team)
    solved_challenge = create(:pentest_solved_challenge, team: team)
    assert_equal solved_challenge.flag.point_value(team), solved_challenge_table_point_value(game, solved_challenge, team)
  end

  test 'header with points' do
    team = create(:point_team)
    assert_includes header_with_points(team), team.team_name
    assert_includes header_with_points(team), team.score.to_s

    Game.first.destroy
    game = create(:active_pentest_game)
    team = create(:pentest_team)
    assert_includes header_with_points(team), team.team_name
    assert_includes header_with_points(team), team.score.to_s
  end
end
