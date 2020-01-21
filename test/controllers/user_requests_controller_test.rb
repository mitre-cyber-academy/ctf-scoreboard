require 'test_helper'

class UserRequestsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"] = 'http://test.host/'
    @game = create(:active_game)
    @team = create(:team)
    @requesting_user = create(:user)
  end

  test 'user cannot create a request with one already pending for same team' do
    create(:user_request, team: @team, user: @requesting_user)
    sign_in @requesting_user
    post :create, params: { team_id: @team }
    assert_redirected_to join_team_users_path
    assert_match I18n.t('requests.already_pending'), flash[:alert]
  end

  test 'user can create request when they do not have any pending requests for that team and are not on a team' do
    sign_in @requesting_user
    post :create, params: { team_id: @team }
    assert_redirected_to join_team_users_path
    assert_equal I18n.t('requests.sent_successful'), flash[:notice]
  end

  test 'accept request' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in @team.team_captain
    get :accept, params: { team_id: @team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.accepted_successful'), flash[:notice]
  end

  test 'accept request but user already on a team' do
    user_on_team = create(:user_with_team)
    user_request = create(:user_request, team: @team, user: user_on_team)
    sign_in @team.team_captain
    get :accept, params: { team_id: @team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.accepted_another'), flash[:alert]
  end

  test 'accept request but user already on a team with no referer' do
    user_on_team = create(:user_with_team)
    user_request = create(:user_request, team: @team, user: user_on_team)
    sign_in @team.team_captain
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { team_id: @team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.accepted_another'), flash[:alert]
  end

  test 'accept request but team now has too many members' do
    full_team = create(:team, additional_member_count: @game.team_size - 1)
    user_request = create(:user_request, team: full_team, user: @requesting_user)
    sign_in full_team.team_captain
    get :accept, params: { team_id: full_team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.too_many_players'), flash[:alert]
  end

  test 'accept request but team now has too many members with no referer' do
    full_team = create(:team, additional_member_count: @game.team_size - 1)
    user_request = create(:user_request, team: full_team, user: @requesting_user)
    sign_in full_team.team_captain
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { team_id: full_team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.too_many_players'), flash[:alert]
  end

  test 'user does not own request so they cannot accept it' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in create(:user)
    assert_raise ActiveRecord::RecordNotFound do
      get :accept, params: { team_id: @team, id: user_request }
    end
  end

  test 'user destroys own request' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in @requesting_user
    delete :destroy, params: { team_id: @team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'user destroys own request no referer' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in @requesting_user
    @request.env["HTTP_REFERER"] = nil
    delete :destroy, params: { team_id: @team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'captain destroys user request' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in @team.team_captain
    delete :destroy, params: { team_id: @team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'captain destroys user request no referer' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in @team.team_captain
    @request.env["HTTP_REFERER"] = nil
    delete :destroy, params: { team_id: @team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'other user not allowed to destroy request' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in create(:user)
    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, params: { team_id: @team, id: user_request }
    end
  end

  test 'team captain can not accept requests while in top ten' do
    team_in_top_ten = create(:team_in_top_ten)
    user_request = create(:user_request, team: team_in_top_ten, user: @requesting_user)
    sign_in team_in_top_ten.team_captain
    get :accept, params: { team_id: team_in_top_ten, id: user_request }
    assert :success
    assert_equal I18n.t('teams.in_top_ten'), flash[:alert]
  end

  test 'delete user request after user deleted' do
    user_request = create(:user_request, team: @team, user: @requesting_user)
    sign_in @team.team_captain
    User.delete(@requesting_user)
    delete :destroy, params: { team_id: @team, id: user_request }
    assert :redirect
    assert_equal 'User must exist', flash['alert']
  end
end
