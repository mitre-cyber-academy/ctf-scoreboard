require 'test_helper'

class UserRequestsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"] = 'http://test.host/'
  end

  test 'create request' do
    sign_in users(:user_two)
    post :create, team_id: teams(:team_one)
    assert_redirected_to user_root_path
    assert_equal I18n.t('requests.sent_successful'), flash[:notice]
  end

  test 'fail to create request' do
  end

  test 'accept request' do
  end

  test 'accept request but user already on a team' do
  end

  test 'accept request but team now has too many members' do
  end

  test 'user not able to accept request' do
  end

  test 'user destroys own request' do
    user = users(:user_two)
    delete :destroy, team_id: user_requests(:request_one).team, id: users(:user_two).id
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal I18n.t('requests.rejected_sucessful'), flash[:notice]
  end

  test 'captain destroys user request' do
  end
end
