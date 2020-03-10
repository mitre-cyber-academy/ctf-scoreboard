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

  test 'challenge text for teams x challenges board' do
    team = create(:team)
    @user = team.team_captain
    challenge = create(:standard_challenge, state: :closed)
    assert_equal '-', challenge_text_for_team_for(challenge, team)
    challenge.update(state: :open)
    assert_equal 'Click to Solve', challenge_text_for_team_for(challenge, team)
    create(:standard_solved_challenge, challenge: challenge, team: team)
    assert_equal 'Solved', challenge_text_for_team_for(challenge, team)
    challenge.update(state: :closed)
    assert_equal 'Solved', challenge_text_for_team_for(challenge, team)
  end

  test 'challenge color' do
    defense_team = create(:team)
    @user = defense_team.team_captain
    challenge = create(:pentest_challenge_with_flags)
    flag = challenge.defense_flags.where(team_id: defense_team.id).first
    assert_equal ['#999999', '#000'], challenge_colors(flag, defense_team)

    challenge.update(state: :force_closed)
    challenge.save
    challenge.reload
    unsolved_team = create(:team)
    @user = unsolved_team.team_captain
    assert_equal ['#800000', '#eee'], challenge_colors(flag, defense_team)

    challenge.update(state: :closed)
    challenge.save
    challenge.reload
    assert_equal ['#999999', '#eee'], challenge_colors(flag, defense_team)

    challenge.update(state: :open)
    challenge.save
    challenge.reload
    assert_equal ['#006600', '#fff'], challenge_colors(flag, defense_team)

    solved_team_one = create(:team)
    create(:pentest_solved_challenge, challenge: challenge, team: solved_team_one, flag: flag)
    flag.reload
    assert_equal ['#009900', '#eee'], challenge_colors(flag, defense_team)

    solved_team_two = create(:team)
    create(:pentest_solved_challenge, challenge: challenge, team: solved_team_two, flag: flag)
    flag.reload
    assert_equal ['#00cc00', '#444'], challenge_colors(flag, defense_team)

    @user = solved_team_one.team_captain
    assert_equal ['#00abca', '#eee'], challenge_colors(flag, defense_team)
  end

  test 'own team challenge' do
    team = create(:team)
    @user = team.team_captain
    assert own_team_challenge?(team)
  end
end
