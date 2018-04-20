require 'test_helper'

class FlagTest < ActiveSupport::TestCase
  test 'can submit flag correctly' do
    org = SubmittedFlag.all.count
    SubmittedFlag.create(user: users(:user_one), challenge: challenges(:challenge_one_cat_one), text: 'flag')
    assert_equal org + 1, SubmittedFlag.all.count
  end

  test 'can not submit flag with no user' do
    org = SubmittedFlag.all.count
    SubmittedFlag.create(challenge: challenges(:challenge_one_cat_one), text: 'flag')
    assert_equal org, SubmittedFlag.all.count
  end

  test 'can not submit flag with no challenge' do
    org = SubmittedFlag.all.count
    SubmittedFlag.create(user: users(:user_one), text: 'flag')
    assert_equal org, SubmittedFlag.all.count
  end

  test 'can not submit flag with no team' do
    org = SubmittedFlag.all.count
    SubmittedFlag.create(user: users(:user_two), challenge: challenges(:challenge_one_cat_one), text: 'flag')
    assert_equal org, SubmittedFlag.all.count
  end
end