require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'can load join a team' do
    sign_in users(:user_two)
    get :join_team
    assert_response :success
  end

  test 'user removes self from a team' do
    sign_in users(:full_team_user_five)
    delete :leave_team, params: { user_id: users(:full_team_user_five).id, team_id: users(:full_team_user_five).team_id }
    assert_redirected_to join_team_users_path
    assert_equal I18n.t('teams.player_removed_self'), flash[:notice]
  end

  # Only one person on this team
  test 'captain removes another team member from team' do
    sign_in users(:full_team_user_one)
    team = users(:full_team_user_one).team
    assert_difference 'team.users.reload.size', -1 do
      delete :leave_team, params: { user_id: users(:full_team_user_five).id, team_id: users(:full_team_user_one).team_id }
    end
    assert_equal I18n.t('teams.captain_removed_player'), flash[:notice]
  end

  test 'captain removes self' do
    sign_in users(:user_one)
    team = users(:user_one).team
    assert_difference 'team.users.reload.size', -1 do
      delete :leave_team, params: { user_id: users(:user_one).id, team_id: team }
    end
    assert_equal I18n.t('teams.player_removed_self'), flash[:notice]
  end

  test 'captain tries to remove self with other users on team' do
    sign_in users(:full_team_user_one)
    team = users(:full_team_user_one).team
    assert_no_difference 'team.users.reload.size' do
      delete :leave_team, params: { user_id: users(:full_team_user_one).id, team_id: team }
    end
    assert_equal I18n.t('teams.captain_must_promote'), flash[:alert]
  end

  test 'only team captain can remove' do
    sign_in users(:full_team_user_five)
    team = users(:full_team_user_five).team
    assert_no_difference 'team.users.reload.size' do
      assert_raise ActiveRecord::RecordNotFound do
        delete :leave_team, params: { user_id: users(:full_team_user_four).id, team_id: users(:full_team_user_five).team_id }
      end
    end
  end

  test 'captain is promoted' do
    sign_in users(:full_team_user_one)
    team = users(:full_team_user_one).team
    get :promote, params: { user_id: users(:full_team_user_five), team_id: team }
    assert :success
    assert_redirected_to team
    assert_equal I18n.t('teams.promoted_captain'), flash[:notice]
  end

  test 'captain is not promoted' do
    sign_in users(:full_team_user_one)
    team = users(:full_team_user_one).team
    get :promote, params: { user_id: users(:user_five), team_id: team } # User 5 is not on full_team
    assert :success
    assert_redirected_to team
    assert_equal I18n.t('teams.cannot_promote_captain'), flash[:alert]
  end

  test 'user cannot promote' do
    sign_in users(:full_team_user_five)
    team = users(:full_team_user_five).team
    assert_raise ActiveRecord::RecordNotFound do
      get :promote, params: { user_id: users(:full_team_user_four), team_id: team }
    end
  end

  test 'captain cannot be from another team' do
    sign_in users(:full_team_user_one)
    team = users(:full_team_user_one).team
    get :promote, params: { user_id: users(:user_two), team_id: team }
    assert_not_equal team.team_captain, users(:user_two)
  end

  test 'team member can not leave team while in top ten' do
    user = users(:user_four)
    sign_in user
    delete :leave_team, params: { user_id: user.id, team_id: user.team.id }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('teams.in_top_ten'), flash[:alert]
  end

  test 'vpn_cert_downloaded is properly updated when the user downloads their certificate' do
    user = users(:full_team_user_one)
    sign_in user
    get :download_vpn_cert
    assert_redirected_to %r(\Ahttps://.*\.s3\.amazonaws\.com)
    assert user.reload.vpn_cert_downloaded
  end

  test 'guest and user cannot access resume' do
    user = add_resume_transcript_to(users(:user_four))
    assert_raises(ActiveRecord::RecordNotFound) do
      get :resume, params: { id: user.id } # Nobody is signed in
    end
    sign_in user
    assert_raises(ActiveRecord::RecordNotFound) do
      get :resume, params: { id: user.id } # User is signed in
    end
  end

  test 'guest and user cannot access transcript' do
    user = add_resume_transcript_to(users(:user_four))
    assert_raises(ActiveRecord::RecordNotFound) do
      get :transcript, params: { id: user.id } # Nobody is signed in
    end
    sign_in user
    assert_raises(ActiveRecord::RecordNotFound) do
      get :transcript, params: { id: user.id } # User is signed in
    end
  end

  test 'admin can access resume' do
    user = add_resume_transcript_to(users(:user_four))
    sign_in users(:admin_user)
    get :resume, params: { id: user.id }
    assert_response :success
    assert_equal "application/pdf", response.content_type
  end

  test 'admin can access transcript' do
    user = add_resume_transcript_to(users(:user_four))
    sign_in users(:admin_user)
    get :transcript, params: { id: user.id }
    assert_response :success
    assert_equal "application/pdf", response.content_type
  end

  test 'admin redirected when resume not available' do
    user = users(:user_four)
    sign_in users(:admin_user)
    get :resume, params: { id: user.id }
    assert_redirected_to rails_admin_path
    assert_equal I18n.t('users.download_not_available'), flash[:alert]
  end

  test 'admin redirected when transcript not available' do
    user = users(:user_four)
    sign_in users(:admin_user)
    get :transcript, params: { id: user.id }
    assert_redirected_to rails_admin_path
    assert_equal I18n.t('users.download_not_available'), flash[:alert]
  end
end
