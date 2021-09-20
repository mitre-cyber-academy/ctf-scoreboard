require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    create(:active_game)
    @team = create(:team, additional_member_count: 5)
    @captain = @team.team_captain
    @non_captain = @team.users.where.not(id: @captain).first
  end

  test 'can load join a team' do
    sign_in create(:user)
    get :join_team
    assert_response :success
  end

  test 'user removes self from a team' do
    sign_in @non_captain
    delete :leave_team, params: { user_id: @non_captain.id, team_id: @team.id }
    assert_redirected_to join_team_users_path
    assert_equal I18n.t('teams.player_removed_self'), flash[:notice]
  end

  # Only one person on this team
  test 'captain removes another team member from team' do
    sign_in @captain
    assert_difference '@team.users.reload.size', -1 do
      delete :leave_team, params: { user_id: @non_captain.id, team_id: @team.id }
    end
    assert_equal I18n.t('teams.captain_removed_player'), flash[:notice]
  end

  test 'captain removes self' do
    single_user = create(:user_with_team)
    sign_in single_user
    team = single_user.team
    assert_difference 'team.users.reload.size', -1 do
      delete :leave_team, params: { user_id: single_user.id, team_id: team }
    end
    assert_equal I18n.t('teams.player_removed_self'), flash[:notice]
  end

  test 'captain tries to remove self with other users on team' do
    sign_in @captain
    assert_no_difference '@team.users.reload.size' do
      delete :leave_team, params: { user_id: @captain.id, team_id: @team.id }
    end
    assert_equal I18n.t('teams.captain_must_promote'), flash[:alert]
  end

  test 'only team captain can remove other players' do
    sign_in @non_captain
    assert_no_difference '@team.users.reload.size' do
      assert_raise ActiveRecord::RecordNotFound do
        delete :leave_team, params: { user_id: @captain.id, team_id: @team.id }
      end
    end
  end

  test 'captain is promoted' do
    sign_in @captain
    get :promote, params: { user_id: @non_captain.id, team_id: @team.id }
    assert :success
    assert_redirected_to @team
    assert_equal I18n.t('teams.promoted_captain'), flash[:notice]
  end

  test 'captain is not promoted since promoted user is not on team' do
    sign_in @captain
    get :promote, params: { user_id: create(:user), team_id: @team } # New user is not on full_team
    assert :success
    assert_redirected_to @team
    assert_equal I18n.t('teams.cannot_promote_captain'), flash[:alert]
  end

  test 'user cannot promote' do
    sign_in create(:user)
    assert_raise ActiveRecord::RecordNotFound do
      get :promote, params: { user_id: @non_captain, team_id: @team }
    end
  end

  test 'captain cannot be from another team' do
    sign_in create(:user_with_team)
    get :promote, params: { user_id: @non_captain, team_id: @team }
    assert_not_equal @team.reload.team_captain, @non_captain
  end

  test 'team member can not leave team while in top ten' do
    team = create(:team_in_top_ten_standard_challenges)
    user = team.team_captain
    sign_in user
    delete :leave_team, params: { user_id: user, team_id: team }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('teams.in_top_ten'), flash[:alert]
  end
end
