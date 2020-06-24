require 'test_helper'

class ScoreAdjustmentTest < ActiveSupport::TestCase
  include ActionView::Helpers::TextHelper

  def setup
    @game = create(:active_game)
  end

  test 'point value is not zero' do
    score_adjustment = build(:score_adjustment, point_value: 0)
    assert_not score_adjustment.valid?
    assert_equal ['must be other than 0'], score_adjustment.errors.messages[:point_value]
  end

  test 'score adjustment adds points to team' do
    team_one = create(:team)
    solved_challenge = create(:standard_solved_challenge, team: team_one)
    assert_equal solved_challenge.challenge.point_value, team_one.score
    score_adjustment = create(:score_adjustment, team: team_one, point_value: 100)
    assert_equal solved_challenge.challenge.point_value + score_adjustment.point_value, team_one.score
  end

  test 'score adjustment properly calculates when multiple PentestSolvedChallenges exist' do
    scoring_team = create(:team)
    offensive_team_1 = create(:team)
    offensive_team_2 = create(:team)
    # These are very basic PentestSolvedChallenges that basically act like regular StandardSolvedChallenges
    # when only 1 team has solved them. That is why the point values can just be summed like they are below.
    # This test is just to verify that the
    create(:pentest_solved_challenge, team: scoring_team, point_value: 100, created_at: @game.start + 1.hour)
    create(:pentest_solved_challenge, team: scoring_team, point_value: 100, created_at: @game.start + 1.hour)
    assert_equal 200, scoring_team.score
    score_adjustment = create(:score_adjustment, team: scoring_team, point_value: 100)
    assert_equal 300, scoring_team.score
  end
end
