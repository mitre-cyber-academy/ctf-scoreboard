require 'test_helper'

class AchievementTest < ActiveSupport::TestCase
  def setup
    create(:active_game)
  end

  test 'description' do
    achievement = create(:achievement)
    description_string =  %(Unlocked Achievement "#{achievement.text}")
    assert_equal description_string, achievement.description
  end

  test 'icon' do
    assert_equal 'certificate', create(:achievement).icon
  end
end
