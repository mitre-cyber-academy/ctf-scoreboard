require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  test 'unauthenticated users should not be able to access new team page' do
    get :new
    assert_redirected_to root_path
  end

  test 'unauthenticated users should not be able to access team show page' do
    get :show, params: { id: teams(:team_one) }
    assert_redirected_to root_path
  end

  test 'unauthenticated users should not be able to access team edit page' do
    get :edit, params: { id: teams(:team_one) }
    assert_redirected_to root_path
  end

  test 'team captain should be able to access team edit page' do
    user = users(:user_one)
    sign_in user
    get :edit, params: { id: user.team }
    assert_response :success
    assert_select 'h1', /Edit your Team/
    assert_select "legend", "New Team Information"
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
    get :show, params: { id: user.team }
    assert_response :success
  end

  test 'authenticated users with a team cannot edit their team unless they are a team captain' do
    user = users(:full_team_user_two)
    sign_in user
    get :edit, params: { id: user.team }
    assert_redirected_to @controller.user_root_path
    assert I18n.t('teams.must_be_team_captain'), flash[:alert]
  end

  test 'users cannot view other teams management' do
    user = users(:user_one)
    sign_in user
    get :show, params: { id: teams(:team_two) }
    assert_redirected_to @controller.user_root_path
  end

  test 'members of a team can view their team management' do
    user = users(:user_one)
    sign_in user
    get :show, params: { id: teams(:team_one) }
    assert_response :success
    assert_select "h4", "Team Prize Eligibility Status"
    assert_select "h4", "Team Division Status"
    assert_select "h3", "Pending User Invites"
    assert_select "h4", "Invite a Team Member"
  end

  test 'authenticated users without a team cannot view teams show page' do
    user = users(:user_two)
    sign_in user
    get :show, params: { id: teams(:team_two) }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('teams.invalid_permissions'), flash[:alert]
  end

  test 'authenticated users without a team can view teams summary page' do
    user = users(:user_two)
    sign_in user
    get :summary, params: { id: teams(:team_two) }
    assert_response :success
    assert_select 'h3', 'Submitted Flags/Hour'
    assert_select 'h3', 'Solved Challenges'
    assert_select 'h3', 'Team Map'
  end

  test 'a team cannot be created with the same name as another team' do
    sign_in users(:user_two)
    assert_no_difference 'Team.count', 'A Team should not be created' do
      post :create, params: { team: { team_name: 'team_one', affiliation: 'school1', division_id: divisions(:high_school) } }
    end
    assert_template :new
  end

  test 'a team cannot be created with the same name as another team in any case' do
    sign_in users(:user_two)
    assert_no_difference 'Team.count', 'A Team should not be created' do
      post :create, params: { team: { team_name: 'TeAm_OnE', affiliation: 'school1', division_id: divisions(:high_school) } }
    end
    assert_template :new
  end

  test 'a team can be created by a user not currently on a team and the current user will be set as the team captain' do
    user = users(:user_two)
    sign_in user
    assert_difference 'Team.count' do
      post :create, params: { team: { team_name: 'another_team', affiliation: 'school1', division_id: divisions(:high_school) } }
    end
    user.reload
    assert_redirected_to team_path(user.team)
    assert_equal user.team.team_captain, user
  end

  test 'a team captain of a full team sees a message informing them that their team is full' do
    user = users(:full_team_user_one)
    sign_in user
    get :show, params: { id: user.team }
    assert_equal flash[:notice], I18n.t('teams.full_team')
  end

  test 'a team member of a full team sees a message informing them that their team is full' do
    user = users(:full_team_user_two)
    sign_in user
    get :show, params: { id: user.team }
    assert_equal flash[:notice], I18n.t('teams.full_team')
  end

  test 'a team captain of a non-full team does not see a message stating that their team is full' do
    user = users(:user_one)
    sign_in user
    get :show, params: { id: user.team }
    assert_not_equal flash[:notice], I18n.t('teams.full_team')
  end

  test 'invite a team member' do
    user = users(:user_one)
    sign_in user
    assert_difference 'user.team.user_invites.count', +1, 'A user invite should be created' do
      patch :invite, params: { team: { user_invites_attributes: { '0': {email: 'mitrectf+user3@gmail.com'} } }, id: user.team }
    end
    assert_redirected_to team_path(users(:user_one).team)
    assert I18n.t('invites.invite_successful'), flash[:notice]
  end

  test 'invite a team member who has already been invited' do
    user = users(:user_one)
    sign_in user
    assert_no_difference 'user.team.user_invites.count', 'A user invite should not be created' do
      patch :invite, params: { team: { user_invites_attributes: { '0': {email: 'mitrectf+user2@gmail.com'}} }, id: user.team }
    end
    assert_redirected_to team_path(users(:user_one).team)
    assert I18n.t('en.activerecord.errors.models.user_invite.attributes.email.uniqueness'), flash[:alert]
  end

  test 'update a team' do
    user = users(:user_one)
    sign_in user
    patch :update, params: { team: { team_name: 'team_one_newname', affiliation: 'school1' }, id: user.team }
    assert_redirected_to team_path(users(:user_one).team)
    assert I18n.t('teams.update_successful'), flash[:notice]
  end

  test 'update a team without permission' do
    user = users(:user_two)
    sign_in user
    patch :update, params: { team: { team_name: 'team_one_newname', affiliation: 'school1' }, id: users(:user_one).team }
    assert_redirected_to @controller.user_root_path
    assert I18n.t('teams.invalid_permissions'), flash[:alert]
  end

  test 'team captain can not send invites while in top ten' do
    team = teams(:team_three)
    sign_in team.team_captain
    patch :invite, params: { team: { user_invites_attributes: { '0': {email: 'mitrectfnewuserfake@mail.google.com'}}}, id: team}
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('teams.in_top_ten'), flash[:alert]
  end


end
