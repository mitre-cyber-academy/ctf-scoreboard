require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'next challenge in category with 3 challenges in sequence' do
    game = create(:active_game)
    category = game.categories.first
    chal1 = create(:standard_challenge, point_value: 100, categories: [category], category_count: 0)
    chal2 = create(:standard_challenge, point_value: 200, categories: [category], category_count: 0, state: :closed)
    chal3 = create(:standard_challenge, point_value: 300, categories: [category], category_count: 0, state: :closed)

    assert_equal chal2, chal1.next_challenge
    assert_nil chal3.next_challenge
  end
end
