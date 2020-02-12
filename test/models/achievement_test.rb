require 'test_helper'

class AchievementTest < ActiveSupport::TestCase
  def setup
    create(:active_point_game)
  end

  test 'description' do
    achievement = create(:point_achievement)
    description_string =  %(Unlocked Achievement "#{achievement.text}")
    assert_equal description_string, achievement.description
  end

  test 'icon' do
    assert_equal 'certificate', create(:point_achievement).icon
  end
end
