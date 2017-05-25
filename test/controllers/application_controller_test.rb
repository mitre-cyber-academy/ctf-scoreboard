require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  test 'to timeline' do
  end

  test 'enable auto reload' do
  end

  test 'load game' do
  end

  test 'load messages count' do
  end

  test 'enforce access' do
  end

  test 'after sign in path' do
  end

  test 'users unread message count is calculated correctly when there is a new message' do
    sign_in users(:user_one)
    @controller.load_game
    assert_equal 1, @controller.load_message_count
  end

  test 'users unread message count is calculated correctly when there are no new messages' do
    user = users(:user_one)
    sign_in user
    user.update_messages_stamp
    @controller.load_game
    assert_equal 0, @controller.load_message_count
  end

  test 'users unread message count is calculated correctly when user is not signed in' do
    @controller.load_game
    assert_nil @controller.load_message_count
  end

  test 'deny team in top ten' do
    # test with game active and inactive
    # Check for alert to see if it worked
  end
end
