require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'next challenge in category with 3 challenges in sequence' do
    game = create(:active_game)
    category = game.categories.first
    chal1 = create(:point_challenge, point_value: 100, categories: [category])
    chal2 = create(:point_challenge, point_value: 200, categories: [category], state: :closed)
    chal3 = create(:point_challenge, point_value: 300, categories: [category], state: :closed)

    assert_equal chal2, category.next_challenge(chal1)
  end
end
