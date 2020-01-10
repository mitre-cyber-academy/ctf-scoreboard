require 'test_helper'

class ScoreAdjustmentTest < ActiveSupport::TestCase
  include ActionView::Helpers::TextHelper

  def setup
    create(:active_game)
  end

  test 'build description' do
    score_increase = create(:score_adjustment, point_value: 100)
    description_string =  %(Score was increased by <span style="color:green;">#{pluralize(score_increase.point_value.abs, 'point')}</span>)
    assert_equal description_string, score_increase.description
    score_decrease = create(:score_adjustment, point_value: -100)
    description_string =  %(Score was decreased by <span style="color:red;">#{pluralize(score_decrease.point_value.abs, 'point')}</span>)
    assert_equal description_string, score_decrease.description
  end

  test 'build icon' do
    assert_equal 'chevron-up', create(:score_adjustment, point_value: 100).icon
    assert_equal 'chevron-down', create(:score_adjustment, point_value: -100).icon
  end

  test 'point value is not zero' do
    score_adjustment = build(:score_adjustment, point_value: 0)
    assert_not score_adjustment.valid?
    assert_equal ['must not be zero.'], score_adjustment.errors.messages[:point_value]
  end

  test 'score adjustment add points to team' do
    team_one = create(:team)
    solved_challenge = create(:solved_challenge, team: team_one)
    assert_equal solved_challenge.challenge.point_value, team_one.score
    score_adjustment = create(:score_adjustment, team: team_one, point_value: 100)
    assert_equal solved_challenge.challenge.point_value + score_adjustment.point_value, team_one.score
  end
end
