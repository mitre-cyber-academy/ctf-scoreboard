require 'test_helper'

class UserInviteTest < ActiveSupport::TestCase
  test 'send email' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      user_invites(:invite_one).send(:send_email)
    end
    email = ActionMailer::Base.deliveries.last
    assert_equal "MITRE CTF: Invite to join team #{teams(:team_one).team_name}", email.subject
    assert_equal [users(:user_two).email.to_s], email.to
  end

  test 'invites are linked to user' do
    assert_difference 'users(:user_two).user_invites(:reload).size', +1 do
      user_invites(:invite_one).send(:link_to_user)
    end
  end

  test 'invites can be accepted' do
    user_invites(:invite_one).send(:link_to_user)
    assert_difference 'user_invites(:invite_one).team.users.size', +1 do
      user_invites(:invite_one).accept
    end
  end

  test 'invites with no linked user cannot be accepted' do
    assert_no_difference 'user_invites(:invite_one).team.users.size' do
      user_invites(:invite_one).accept
    end
  end
end
