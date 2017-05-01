require 'test_helper'

class AchievementTest < ActiveSupport::TestCase
  test 'description' do
    text = feed_items(:feed_item_three).text
    description_string =  %(Unlocked achievement "#{text}")
    assert_equal description_string, feed_items(:feed_item_three).description
  end

  test 'icon' do
    icon_string = 'certificate'
    assert_equal icon_string, feed_items(:feed_item_three).icon
  end
end