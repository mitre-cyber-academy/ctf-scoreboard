require 'test_helper'

class ScoreAdjustmentTest < ActiveSupport::TestCase
  include ActionView::Helpers::TextHelper

  def setup
    create(:active_game)
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
    # TODO: Add PentestSolvedChallenge here and assert its value gets added as well
    score_adjustment = create(:score_adjustment, team: team_one, point_value: 100)
    assert_equal solved_challenge.challenge.point_value + score_adjustment.point_value, team_one.score
  end
end
