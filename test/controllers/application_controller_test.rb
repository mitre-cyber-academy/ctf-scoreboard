require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def setup
    create(:active_game)
    @user = create(:user)
  end

  test 'users unread message count is calculated correctly when there is a new message' do
    sign_in @user
    @controller.load_game
    assert_equal 1, @controller.load_message_count
  end

  test 'users unread message count is calculated correctly when there are no new messages' do
    sign_in @user
    @user.update_messages_stamp
    @controller.load_game
    assert_equal 0, @controller.load_message_count
  end

  test 'users unread message count is calculated correctly when user is not signed in' do
    @controller.load_game
    assert_nil @controller.load_message_count
  end
end
