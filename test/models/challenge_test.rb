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

  test 'get current solved challenge' do
    assert_nil challenges(:challenge_one_cat_one).get_current_solved_challenge(users(:user_one))
    assert_equal feed_items(:solved_challenge_one), challenges(:challenge_three_cat_one).get_current_solved_challenge(teams(:team_two))
  end

  test 'solved by user' do
    assert_equal false, challenges(:challenge_one_cat_one).solved_by_user?(users(:user_one))
    assert_equal true, challenges(:challenge_three_cat_one).solved_by_user?(users(:user_two))
  end

  test 'get video url for flag' do
    # current challenge nil
    assert_nil challenges(:challenge_one_cat_one).get_video_url_for_flag(users(:user_one))
    # current challenge flag nil
    assert_nil challenges(:challenge_two_cat_one).get_video_url_for_flag(users(:user_one))
    # current challenge solved
    assert_equal flags(:flag_three).video_url, challenges(:challenge_three_cat_one).get_video_url_for_flag(teams(:team_two))
  end

  test 'get api request for flag' do
    # current challenge nil
    assert_nil challenges(:challenge_one_cat_one).get_api_request_for_flag(users(:user_one))
    # current challenge flag nil
    assert_nil challenges(:challenge_two_cat_one).get_api_request_for_flag(users(:user_one))
    # current challenge solved
    assert_equal flags(:flag_three).api_url, challenges(:challenge_three_cat_one).get_api_request_for_flag(teams(:team_two))
  end

  test 'set state' do
    challenges(:challenge_one_cat_one).set_state('force_closed')
    assert_equal 'force_closed', challenges(:challenge_one_cat_one).state
  end
end
