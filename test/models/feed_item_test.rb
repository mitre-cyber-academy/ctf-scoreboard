require 'test_helper'

class FeedItemTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_jeopardy_game)
    @achievement = create(:achievement)
    @solved_challenge = create(:point_solved_challenge, challenge: create(:point_challenge, category: create(:category, game: @game)))
    @score_adjustment = create(:score_adjustment)
  end

  test 'description' do
    assert_includes @achievement.description, @achievement.class.name
    assert_includes @solved_challenge.description, @solved_challenge.challenge.category.name
  end

  test 'icon' do
    assert_equal @solved_challenge.icon, 'ok'
    assert_equal @achievement.icon, 'certificate'
    assert_equal @score_adjustment.icon, 'chevron-up'
  end
end
