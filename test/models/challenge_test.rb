require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase

  test 'challenge state open' do
    assert_equal true, challenges(:challenge_one_cat_one).challenge_open?
    assert_equal false, challenges(:challenge_three_cat_one).challenge_open?
  end

  test 'challenge open' do
    assert_equal true, challenges(:challenge_one_cat_one).open?
  end

  test 'challenge solved' do
    assert_equal false, challenges(:challenge_one_cat_one).solved?
  end

  test 'challenge available' do
    assert_equal false, challenges(:challenge_one_cat_one).available?
  end

  test 'challenge force closed' do
    assert_equal true, challenges(:challenge_two_cat_one).force_closed?
  end

  test 'set state' do
    challenges(:challenge_one_cat_one).set_state('force_closed')
    assert_equal 'force_closed', challenges(:challenge_one_cat_one).state
  end
end
