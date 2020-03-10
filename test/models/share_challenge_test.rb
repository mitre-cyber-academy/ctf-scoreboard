require 'test_helper'

class ShareChallengeTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_game)
    @defense_team = create(:team)
    @challenge = create(
                  :share_challenge,
                  point_value: 100,
                  first_capture_point_bonus: 10,
                  initial_shares: 1000,
                  unsolved_increment_period: 1, # Hours
                  unsolved_increment_points: 0,
                  solved_decrement_period: 1, # Hours
                  solved_decrement_shares: 0,
                  defense_period: 1, # Hours
                  defense_points: 0,
                  flag_count: 1
                )
  end

  test 'point value' do
    solve_team = create(:team)
    unsolve_team = create(:team)
    solved_challenge = create(:standard_solved_challenge, team: solve_team, challenge: @challenge)
    assert_equal 110, @challenge.display_point_value(solve_team)
    assert_equal 50, @challenge.display_point_value(unsolve_team)
    assert_equal 0, @challenge.calc_defensive_points, 'Share challenges should not return defensive points'
  end

  test 'challenge open?' do
    assert @challenge.challenge_open?

    @challenge.update(state: :closed)

    assert_not @challenge.challenge_open?
  end
end
