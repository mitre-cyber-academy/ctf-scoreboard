require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_game, division_count: 2, start: 1.hour.ago, stop: 10.hours.from_now)
    @division = @game.divisions.first
    create_list(:team, 10, division: @division)
    create_list(:team, 10, division: @division, compete_for_prizes: true)

    @ptest_challenge = create(
                      :pentest_challenge,
                      point_value: 100,
                      first_capture_point_bonus: 75,
                      initial_shares: 1000,
                      unsolved_increment_period: 2, # Hours
                      unsolved_increment_points: 100,
                      solved_decrement_period: 2, # Hours
                      solved_decrement_shares: 200,
                      defense_period: 2, # Hours
                      defense_points: 200,
                      flag_count: 0
                    )
  end

  test 'sort all players and ensure both lists are the same length' do
    ordered_teams = @division.ordered_teams
    assert_equal @division.teams.size, ordered_teams.size

    # All the indexes of teams who are eligible should be to the left of indexes of ineligible teams
    eligible_team_locations = ordered_teams.collect(&:eligible)
    assert eligible_team_locations.index(true) < eligible_team_locations.index(false)
  end

  test 'top five eligible players' do
    ordered_teams = @division.ordered_teams(true)
    assert_operator 5, :>=, ordered_teams.size
  end

  # Since the team score is proxied through the division, it makes sense to test it along with the
  # other division code
  test 'a solved challenge calculates offensive and defensive points properly' do
    defensive_team = create(:team, division: @division)
    flag = create(:defense_flag, challenge: @ptest_challenge, team: defensive_team)
    @game = create(:active_game, start: 2.hours.ago)
    offensive_team = create(:team, division: @division)
    assert_equal 200, defensive_team.score
    assert_equal 0, offensive_team.score
    create(:pentest_solved_challenge, team: offensive_team, challenge: @ptest_challenge, created_at: @game.start + 1.hour)
    # We create the pentest_solved_challenge in the past so the defense score decreases in this case
    assert_equal 100, defensive_team.score
    assert_equal true, flag.solved?
    assert_equal 225, offensive_team.score
  end

  # Team 1 solves the challenge 1 hour after the game starts. (worth 1000 shares)
  # This makes the challenge worth 100 + 50 = 150 points
  # Defensive scoring therefore stops after 1 hour (worth 100 defensive points)
  # Team 2 solves the challenge 2 hours after the game starts. (worth 990 shares)
  # Team 3 solves the challenge 4 hours after the game starts. (worth 985 shares)
  test 'shares are properly divided between teams' do
    defensive_team = create(:team, division: @division)
    flag = create(:defense_flag, challenge: @ptest_challenge, team: defensive_team)
    @game = create(:active_game, start: 4.hours.ago)
    teams = create_list(:team, 3, division: @division)
    create(:pentest_solved_challenge, team: teams[0], challenge: @ptest_challenge, created_at: @game.start + 1.hour)
    # First point capture bonus is 75 points + 1000 shares for initial solve
    # Challenge is worth 100 initial value + 50 unsolved increment points = 150 (plus 75 from previous comment)
    assert_equal 225, teams[0].score
    create(:pentest_solved_challenge, team: teams[1], challenge: @ptest_challenge, created_at: @game.start + 2.hours)
    # Challenge is still worth 150, it just gets divided between 2 teams now, first team keeps first capture bonus
    # Challenge is worth 100 shares less for 2nd team due to solved_decrement_shares / solved_decrement_period
    # Shares are now divided between 2 teams, first team has 1000, second team has 900 shares
    # First team now has (1000/1900 * 150) ~= 78.9 which rounds to 79 points + 75 points for first capture.
    assert_equal 154, teams[0].score
    # Second team now has (900/1900 * 150) ~= 71.0 which rounds to 71 points.
    assert_equal 71, teams[1].score
    create(:pentest_solved_challenge, team: teams[2], challenge: @ptest_challenge, created_at: @game.start + 4.hours)
    # Challenge is still worth 150, however it is now divided between 3 teams.
    # Challenge is worth 200 shares less for the 3rd team since 1.5 solved_decrement_periods have passed
    # Shares are now divided between 2 teams, first team has 1000, second team has 900 shares, third has 700 shares
    # First team now has (1000/2600 * 150) ~= 57.6 which rounds to 58 points + 75 points for first capture.
    assert_equal 133, teams[0].score
    # Second team now has (900/2600 * 150) ~= 51.9 which rounds to 52 points.
    assert_equal 52, teams[1].score
    # Third team now has (700/2600 * 150) ~= 40.3 which rounds to 40 points.
    assert_equal 40, teams[2].score
  end

  test 'calculations stop when the game ends' do
    defensive_team = create(:team, division: @division)
    flag = create(:defense_flag, challenge: @ptest_challenge, team: defensive_team)
    @game = create(:active_game, start: 2.hours.ago, stop: Time.now.utc)
    offensive_team = create(:team, division: @division)
    assert_equal 200, defensive_team.score
    @game.update(stop: 1.hour.ago)
    assert_equal 100, defensive_team.score
  end

  test 'share pentest and point challenges are properly calculated all together' do
    defensive_team = create(:team, division: @division)
    flag = create(:defense_flag, challenge: @ptest_challenge, team: defensive_team)
    offensive_team = create(:team, division: @division)
    create(:pentest_solved_challenge, team: offensive_team, challenge: @ptest_challenge, created_at: @game.start + 1.hour)
    assert_equal 225, offensive_team.score
    share_challenge = create(
                  :share_challenge,
                  point_value: 100,
                  first_capture_point_bonus: 75,
                  initial_shares: 1000,
                  unsolved_increment_period: 2, # Hours
                  unsolved_increment_points: 100,
                  solved_decrement_period: 2, # Hours
                  solved_decrement_shares: 200,
                  flag_count: 1
                )
    # This challenge has the exact same point configuration as the pentest_challenge above
    create(:standard_solved_challenge, team: offensive_team, challenge: share_challenge, created_at: @game.start + 1.hour)
    assert_equal 450, offensive_team.score
    point_challenge = create(:standard_challenge, point_value: 100)
    create(:standard_solved_challenge, team: offensive_team, challenge: point_challenge)
    assert_equal 550, offensive_team.score
  end

  test 'two teams with the same pentest score will be sorted by last solve' do
    division = @game.divisions.last
    teams = create_list(:team, 2, division: division)
    challenges = create_list(:pentest_challenge_with_flags, 2, point_value: 100)
    create(:pentest_solved_challenge, challenge: challenges[0], team: teams[0], created_at: 10.minutes.ago)
    create(:pentest_solved_challenge, challenge: challenges[1], team: teams[1], created_at: 59.minutes.ago)
    assert_equal teams[1], division.ordered_teams.first
    assert_equal teams[0], division.ordered_teams.second
  end
end
