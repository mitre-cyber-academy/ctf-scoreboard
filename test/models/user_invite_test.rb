require 'test_helper'

class UserInviteTest < ActiveSupport::TestCase

  def setup
    # create a mailer here and use it to call private functions
    @user_invite = UserInvite.create!(
      email: users(:user_two).email,
      team: teams(:team_one)
    )
  end

  test "send email" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      user_invites(:invite_one).send(:send_email)
    end
    email = ActionMailer::Base.deliveries.last
    assert_equal "MITRE CTF: Invite to join team #{teams(:team_one).team_name}", email.subject
    assert_equal ["#{users(:user_two).email}"], email.to
  end

  test "invites are linked to user" do
    assert_difference 'users(:user_two).user_invites.size', +1 do
      user_invites(:invite_one).send(:link_to_user)
    end
  end
end
