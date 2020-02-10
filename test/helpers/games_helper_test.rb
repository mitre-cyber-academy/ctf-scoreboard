require 'test_helper'

class GamesHelperTest < ActionView::TestCase
  def current_user
    return @user
  end

  test 'team or category' do
    game = create(:active_point_game)
    assert_equal 'category', team_or_category(game)

    Game.first.destroy
    game = create(:active_pentest_game)
    assert_equal 'team', team_or_category(game)
  end

  test 'heading width' do
    game = create(:active_point_game)
    headings = game.load_categories_or_teams
    assert_equal 100, heading_width(headings)

    Game.first.destroy
    game = create(:active_point_game, category_count: 5)
    headings = game.load_categories_or_teams
    assert_equal 20, heading_width(headings)
  end

  test 'cell background color' do
    game = create(:active_pentest_game)
    team = create(:pentest_team)
    @user = team.team_captain

    assert_equal 'background-color: #F0F0F0;', cell_background_color(team.team_name)

    @user = create(:user)

    assert_equal '', cell_background_color(team.team_name)
  end

  test 'challenge color' do
    game = create(:active_pentest_game)
    defense_team = create(:pentest_team)
    @user = defense_team.team_captain
    challenge = create(:pentest_challenge_with_flags, pentest_game: game)
    flag = challenge.flags.where(team_id: defense_team.id).first
    assert_equal 'color:#999999;', challenge_color(flag, defense_team)

    challenge.update(state: 'force_closed')
    challenge.save
    challenge.reload
    unsolved_team = create(:pentest_team)
    @user = unsolved_team.team_captain
    assert_equal 'color:#800000;', challenge_color(flag, defense_team)

    challenge.update(state: 'closed')
    challenge.save
    challenge.reload
    assert_equal 'color:#999999;', challenge_color(flag, defense_team)

    challenge.update(state: 'open')
    challenge.save
    challenge.reload
    assert_equal 'color:#006600;', challenge_color(flag, defense_team)

    solved_team_one = create(:pentest_team)
    create(:pentest_solved_challenge, challenge: challenge, team: solved_team_one, flag: flag)
    flag.reload
    assert_equal 'color:#009900;', challenge_color(flag, defense_team)

    solved_team_two = create(:pentest_team)
    create(:pentest_solved_challenge, challenge: challenge, team: solved_team_two, flag: flag)
    flag.reload
    assert_equal 'color:#00cc00;', challenge_color(flag, defense_team)

    @user = solved_team_one.team_captain
    assert_equal 'color:#00abca;', challenge_color(flag, defense_team)
  end

  test 'own team challenge' do
    game = create(:active_pentest_game)
    team = create(:pentest_team)
    @user = team.team_captain
    assert own_team_challenge?(team)
  end

  test 'get team by name' do
    game = create(:active_point_game)
    team = create(:point_team)

    assert_equal team.id, get_team_by_name(game.teams, team.team_name)
  end
end
