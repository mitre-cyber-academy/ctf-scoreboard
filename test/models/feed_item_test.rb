require 'test_helper'

class FeedItemTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_game)
    @achievement = create(:point_achievement)
    @solved_challenge = create(:point_solved_challenge, challenge: create(:point_challenge, category: create(:category, game: @game)))
    @score_adjustment = create(:score_adjustment)
  end
end
