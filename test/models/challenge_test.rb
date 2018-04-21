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
    challenges(:challenge_one_cat_one).state!('force_closed')
    assert_equal 'force_closed', challenges(:challenge_one_cat_one).state
  end

  test 'post state change message' do
    open_challenge = challenges(:challenge_one_cat_one)
    forced_challenge = challenges(:challenge_four_cat_two)
    assert_difference 'Message.count', +2 do
      open_challenge.update_attributes(state: 'force_closed')
      forced_challenge.update_attributes(state: 'open')
    end
    message = Message.last
    assert I18n.t('challenge.state_change_message', state: 'open'.titleize), message.title
  end
end
