require 'test_helper'

class GamesHelperTest < ActionView::TestCase
  def current_user
    return @user
  end

  def setup
    @game = create(:active_game)
  end

  test 'heading width' do
    # Setup creates @game which automatically creates 1 category, we create 4
    # more for a total of 5 categories.
    @game = create(:active_game, category_count: 4)
    assert_equal 20, heading_width(@game.categories)
  end

  test 'cell background color' do
    team = create(:team)
    @user = team.team_captain

    assert_equal 'background-color: #F0F0F0;', cell_background_color(team)

    @user = create(:user)

    assert_equal '', cell_background_color(team)
  end

  test 'challenge color' do
    defense_team = create(:team)
    @user = defense_team.team_captain
    challenge = create(:pentest_challenge_with_flags)
    flag = challenge.defense_flags.where(team_id: defense_team.id).first
    assert_equal 'color:#999999;', challenge_color(flag, defense_team)

    challenge.update(state: 'force_closed')
    challenge.save
    challenge.reload
    unsolved_team = create(:team)
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

    solved_team_one = create(:team)
    create(:pentest_solved_challenge, challenge: challenge, team: solved_team_one, flag: flag)
    flag.reload
    assert_equal 'color:#009900;', challenge_color(flag, defense_team)

    solved_team_two = create(:team)
    create(:pentest_solved_challenge, challenge: challenge, team: solved_team_two, flag: flag)
    flag.reload
    assert_equal 'color:#00cc00;', challenge_color(flag, defense_team)

    @user = solved_team_one.team_captain
    assert_equal 'color:#00abca;', challenge_color(flag, defense_team)
  end

  test 'own team challenge' do
    team = create(:team)
    @user = team.team_captain
    assert own_team_challenge?(team)
  end
end
