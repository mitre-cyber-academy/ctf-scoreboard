require 'test_helper'

class UserInvitesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"] = 'http://test.com/'
    Team.find_each{|team| Team.reset_counters team.id, :users}
  end

  test 'accept invite' do
    user = users(:user_two)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_one)
    sign_in user
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to team_path(user_invite.team)
    assert_equal I18n.t('invites.accepted_successful'), flash[:notice]
  end

  test 'unable to accept full team invite' do
    user = users(:user_two)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_four)
    sign_in user
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.full_team'), flash[:alert]
  end

  test 'unable to accept full team invite with no referer' do
    user = users(:user_two)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_four)
    sign_in user
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to join_team_users_path
    assert_equal I18n.t('invites.full_team'), flash[:alert]
  end

  test 'user revokes own invitation' do
    user = users(:user_two)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_one)
    sign_in user
    delete :destroy, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.rejected_successful'), flash[:notice]
  end

  test 'captain revokes invitation' do
    user = users(:user_two)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_one)
    sign_in users(:user_one)
    delete :destroy, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.rejected_successful'), flash[:notice]
  end

  test 'captain revokes invitation with no referer' do
    user = users(:user_two)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_one)
    sign_in users(:user_one)
    @request.env["HTTP_REFERER"] = nil
    delete :destroy, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('invites.rejected_successful'), flash[:notice]
  end

  test 'other user not allowed to accept invite' do
    user = users(:user_six)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_three)
    sign_in users(:user_five)
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.invalid_permissions'), flash[:alert]
  end

  test 'other user not allowed to accept invite with no referer' do
    user = users(:user_six)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_three)
    sign_in users(:user_five)
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('invites.invalid_permissions'), flash[:alert]
  end

  test 'other user not allowed to delete invite' do
    user = users(:user_six)
    user.send(:link_to_invitations)
    user_invite = user_invites(:invite_three)
    sign_in users(:user_five)
    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, params: { id: user_invite, team_id: user_invite.team }
    end
  end
end
