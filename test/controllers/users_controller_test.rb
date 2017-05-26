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
end
