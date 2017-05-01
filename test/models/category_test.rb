require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'next challenge' do
    category_one = categories(:category_two)
    challenge_one = challenges(:challenge_four_cat_two)
    assert_equal challenges(:challenge_five_cat_two), category_one.next_challenge(challenge_one)
  end
end