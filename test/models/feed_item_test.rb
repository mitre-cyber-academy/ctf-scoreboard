require 'test_helper'

class FeedItemTest < ActiveSupport::TestCase
  test 'icon' do
    assert_equal '', feed_items(:feed_item_standard).icon
  end
end