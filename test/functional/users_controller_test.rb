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
    delete :leave_team, user_id: users(:full_team_user_five).id, team_id: users(:full_team_user_five).team_id
    assert_redirected_to join_team_users_path
    assert_equal I18n.t('teams.player_removed_self'), flash[:notice]
  end

  # Only one person on this team
  test 'captain removes another team member from team' do
    sign_in users(:full_team_user_one)
    team = users(:full_team_user_one).team
    assert_difference 'team.users(:relaod).size', -1 do
      delete :leave_team, user_id: users(:full_team_user_five).id, team_id: users(:full_team_user_five).team_id
    end
    assert_equal I18n.t('teams.captain_removed_player'), flash[:notice]
  end

  # test 'captain removes self' do
  #   sign_in users(:full_team_user_one)
  #   delete :leave_team, user_id: users(:full_team_user_one).id, team_id: users(:full_team_user_five).team_id
  #   assert_equal
  # end

  test 'only team captain can remove' do
    sign_in users(:full_team_user_five)
    team = users(:full_team_user_five).team
    assert_no_difference 'team.users(:reload).size' do
      assert_raise ActiveRecord::RecordNotFound do
        delete :leave_team, user_id: users(:full_team_user_four).id, team_id: users(:full_team_user_five).team_id
      end
    end
  end
end
