require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'next challenge' do
    assert_equal challenges(:challenge_five_cat_two), categories(:category_two).next_challenge(challenges(:challenge_four_cat_two))
  end
end