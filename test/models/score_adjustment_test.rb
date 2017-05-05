require 'test_helper'

class ScoreAdjustmentTest < ActiveSupport::TestCase
  include ActionView::Helpers::TextHelper

  test 'build description' do
    points = feed_items(:score_adjustment_one).point_value
    description_string =  %(Score was increased by <span style="color:green;">#{pluralize(points.abs, 'point')}</span>)
    assert_equal description_string, feed_items(:score_adjustment_one).description
    points = feed_items(:score_adjustment_two).point_value
    description_string =  %(Score was decreased by <span style="color:red;">#{pluralize(points.abs, 'point')}</span>)
    assert_equal description_string, feed_items(:score_adjustment_two).description
  end

  test 'build icon' do
    assert_equal 'chevron-up', feed_items(:score_adjustment_one).icon
    assert_equal 'chevron-down', feed_items(:score_adjustment_two).icon
  end

  test 'point value is not zero' do
    score_adjustment = ScoreAdjustment.new(
      point_value: 0)
    assert_not score_adjustment.valid?
    assert_equal ['must not be zero.'], score_adjustment.errors.messages[:point_value]
  end

  test 'score adjustment add points to team' do
    team_one = teams(:team_one)
    # Player 1 has a 200 point score adjustment added from the fixtures
    assert_equal 200, team_one.score
    ScoreAdjustment.create!(player: team_one, point_value: 100, text: 'Did real good on a challenge')
  end
end
