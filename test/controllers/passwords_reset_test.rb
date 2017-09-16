require 'test_helper'

class PasswordsResetTest < ActionDispatch::IntegrationTest
  test 'user can reset password' do
    user = users(:user_one)
    old_password = user.encrypted_password

    assert_difference('ActionMailer::Base.deliveries.count', 1) do
      post user_password_path, params: {user: {email: user.email}}
      assert_redirected_to new_user_session_path
    end

    message = ActionMailer::Base.deliveries[0].to_s
    rpt_index = message.index('reset_password_token')+'reset_password_token'.length+1
    reset_password_token = message[rpt_index...message.index("\"", rpt_index)]

    user.reload
    assert_not_nil user.reset_password_token

    # check for a bad token
    put '/users/password', params: {user: {
        reset_password_token: 'bad reset token',
        password: 'Ch1ck3n4me',
        password_confirmation: 'Ch1ck3n4me',
    }}

    assert_match 'error', response.body
    assert_equal user.encrypted_password, old_password

    # valid password update
    put '/users/password', params: {user: {
        reset_password_token: reset_password_token,
        password: 'Ch1ck3n4me',
        password_confirmation: 'Ch1ck3n4me',
    }}

    assert_redirected_to '/game/summary'

    user.reload
    assert_not_equal(user.encrypted_password, old_password)
  end
end
