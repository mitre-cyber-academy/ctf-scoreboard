require 'test_helper'

class UserRequestsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"] = 'http://test.host/'
    Game.instance.reload_user_count
  end

  test 'user cannot create a request with one already pending for same team' do
    sign_in users(:user_two)
    post :create, params: { team_id: teams(:team_one) }
    assert_redirected_to join_team_users_path
    assert_match I18n.t('requests.already_pending'), flash[:alert]
  end

  test 'user can create request when they do not have any pending requests for that team and are not on a team' do
    sign_in users(:user_three)
    post :create, params: { team_id: teams(:team_one) }
    assert_redirected_to join_team_users_path
    assert_equal I18n.t('requests.sent_successful'), flash[:notice]
  end

  test 'fail to create request' do
  end

  test 'accept request' do
    user_request = user_requests(:request_one)
    sign_in users(:user_one)
    get :accept, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.accepted_successful'), flash[:notice]
  end

  test 'accept request but user already on a team' do
    user_request = user_requests(:request_three)
    sign_in users(:user_one)
    get :accept, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.accepted_another'), flash[:alert]
  end

  test 'accept request but user already on a team with no referer' do
    user_request = user_requests(:request_three)
    sign_in users(:user_one)
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.accepted_another'), flash[:alert]
  end

  test 'accept request but team now has too many members' do
    user_request = user_requests(:request_two)
    sign_in users(:full_team_user_one)
    get :accept, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.too_many_players'), flash[:alert]
  end

  test 'accept request but team now has too many members with no referer' do
    user_request = user_requests(:request_two)
    sign_in users(:full_team_user_one)
    @request.env["HTTP_REFERER"] = nil
    get :accept, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.too_many_players'), flash[:alert]
  end

  test 'user not able to accept request' do
    user_request = user_requests(:request_four)
    sign_in users(:user_six)
    assert_raise ActiveRecord::RecordNotFound do
      get :accept, params: { team_id: user_request.team, id: user_request }
    end
  end

  test 'user destroys own request' do
    user_request = user_requests(:request_one)
    sign_in users(:user_two)
    delete :destroy, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'user destroys own request no referer' do
    user_request = user_requests(:request_one)
    sign_in users(:user_two)
    @request.env["HTTP_REFERER"] = nil
    delete :destroy, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'captain destroys user request' do
    user_request = user_requests(:request_one)
    sign_in users(:user_one)
    delete :destroy, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'captain destroys user request no referer' do
    user_request = user_requests(:request_one)
    sign_in users(:user_one)
    @request.env["HTTP_REFERER"] = nil
    delete :destroy, params: { team_id: user_request.team, id: user_request }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('requests.rejected_successful'), flash[:notice]
  end

  test 'other user not allowed to destroy request' do
    user_request = user_requests(:request_four)
    sign_in users(:user_five)
    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, params: { team_id: user_request.team, id: user_request }
    end
  end

  test 'team captain can not accept requests while in top ten' do
    user_request = user_requests(:request_five)
    sign_in user_request.team.team_captain
    get :accept, params: { team_id: user_request.team, id: user_request }
    assert :success
    assert_equal I18n.t('teams.in_top_ten'), flash[:alert]
  end
end
