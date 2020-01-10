require 'test_helper'

class UserInvitesControllerTest < ActionController::TestCase

  def setup
    @request.env["HTTP_REFERER"] = 'http://test.com/'
    @game = create(:active_game)
    @email = 'mitrectf+user2@gmail.com'
    @invited_user = create(:user, email: @email)
  end

  test 'accept invite' do
    team = create(:team)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in @invited_user
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to team_path(user_invite.team)
    assert_equal I18n.t('invites.accepted_successful'), flash[:notice]
  end

  test 'unable to accept full team invite' do
    team = create(:team, additional_member_count: @game.team_size - 1)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in @invited_user
    get :accept, params: { id: user_invite, team_id: team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.full_team'), flash[:alert]
  end

  test 'unable to accept full team invite with no referer' do
    team = create(:team, additional_member_count: @game.team_size - 1)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in @invited_user
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { id: user_invite, team_id: team }
    assert_redirected_to join_team_users_path
    assert_equal I18n.t('invites.full_team'), flash[:alert]
  end

  test 'user revokes own invitation' do
    team = create(:team)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in @invited_user
    delete :destroy, params: { id: user_invite, team_id: team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.rejected_successful'), flash[:notice]
  end

  test 'captain revokes invitation' do
    team = create(:team)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in team.team_captain
    delete :destroy, params: { id: user_invite, team_id: team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.rejected_successful'), flash[:notice]
  end

  test 'captain revokes invitation with no referer' do
    team = create(:team)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in team.team_captain
    @request.env["HTTP_REFERER"] = nil
    delete :destroy, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('invites.rejected_successful'), flash[:notice]
  end

  test 'other user not allowed to accept invite' do
    team = create(:team)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in create(:user)
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('invites.invalid_permissions'), flash[:alert]
  end

  test 'other user not allowed to accept invite with no referer' do
    team = create(:team)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in create(:user)
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { id: user_invite, team_id: user_invite.team }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('invites.invalid_permissions'), flash[:alert]
  end

  test 'other user not allowed to delete invite' do
    team = create(:team)
    user_invite = create(:user_invite, email: @email, team: team)
    sign_in create(:user)
    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, params: { id: user_invite, team_id: user_invite.team }
    end
  end
end
