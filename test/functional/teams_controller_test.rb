require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  test 'unauthenticated users should not be able to access new team page' do
    get :new
    assert_redirected_to root_path
  end

  test 'unauthenticated users should not be able to access team show page' do
    get :show, id: teams(:team_one)
    assert_redirected_to root_path
  end

  test 'authenticated users with no team should be able to access new team page' do
    sign_in users(:user_three)
    get :new
    assert_response :success
  end

  test 'authenticated users with a team should not be able to access new team page' do
    user = users(:user_one)
    sign_in user
    get :new
    assert_redirected_to team_path(user.team)
  end

  test 'authenticated users with a team can view their team' do
    user = users(:user_one)
    sign_in user
    get :show, id: user.team
    assert_response :success
  end

  test 'authenticated users with a team cannot view other teams' do
    user = users(:user_one)
    sign_in user
    get :show, id: teams(:team_two)
    assert_redirected_to team_path(user.team)
    assert_equal flash[:alert], I18n.t('teams.invalid_permissions')
  end

  test 'authenticated users without a team cannot view other teams' do
    user = users(:user_two)
    sign_in user
    get :show, id: teams(:team_two)
    assert_redirected_to join_team_users_path
  end

  test 'a team cannot be created with the same name as another team' do
    sign_in users(:user_two)
    assert_no_difference 'Team.count', 'A Team should not be created' do
      post :create, team: { team_name: 'team_one', affiliation: 'school1' }
    end
    assert_template :new
  end

  test 'a team cannot be created with the same name as another team in any case' do
    sign_in users(:user_two)
    assert_no_difference 'Team.count', 'A Team should not be created' do
      post :create, team: { team_name: 'TeAm_OnE', affiliation: 'school1' }
    end
    assert_template :new
  end

  test 'a team can be created by a user not currently on a team and the current user will be set as the team captain' do
    user = users(:user_two)
    sign_in user
    assert_difference 'Team.count' do
      post :create, team: { team_name: 'another_team', affiliation: 'school1' }
    end
    user.reload
    assert_redirected_to team_path(user.team)
    assert_equal user.team.team_captain, user
  end

  test 'a team captain of a full team sees a message informing them that their team is full' do
    user = users(:full_team_user_one)
    sign_in user
    get :show, id: user.team
    assert_equal flash[:notice], I18n.t('teams.full_team')
  end

  test 'invite a team member' do
    user = users(:user_one)
    sign_in user
    patch :update, team: { team_name: 'team_one', affiliation: 'school1' }, id: user.team
    assert_redirected_to team_path(users(:user_one).team)
    assert I18n.t('invites.invite_successful'), flash[:notice]
  end
end
