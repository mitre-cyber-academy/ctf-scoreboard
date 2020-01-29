require 'test_helper'

class UserInviteTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_jeopardy_game)
    @email = 'mitrectf+test@gmail.com'
    @team = create(:point_team)
    @user_to_invite = create(:user, email: @email)
  end

  test 'send email' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      create(:point_user_invite, email: @email, team: @team)
    end
    email = ActionMailer::Base.deliveries.last
    assert_equal "#{@game.title}: Invite to join team #{@team.team_name}", email.subject
    assert_equal [@user_to_invite.email.to_s], email.to
  end

  test 'invites are linked to user' do
    assert_difference '@user_to_invite.user_invites.reload.size', +1 do
      invite = create(:point_user_invite, email: @user_to_invite.email, team: @team)
    end
  end

  test 'invites can be accepted' do
    invite = create(:point_user_invite, email: @user_to_invite.email, team: @team)
    assert_difference '@team.users.size', +1 do
      invite.accept
    end
  end

  test 'invites with no linked user cannot be accepted' do
    invite = create(:point_user_invite, email: 'mitrectf+unregistereduser@gmail.com', team: @team)
    assert_no_difference 'invite.team.users.size' do
      invite.accept
    end
  end
end
