require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @password = 'TestPassword123'
  end

  test 'unable to destroy team captain' do
    sign_in users(:user_one)
    delete :destroy, params: { id: users(:user_one).id }
    assert :success
    assert_equal I18n.t("devise.registrations.captain_tried_to_destroy"), flash[:alert]
  end

  test 'destroy user on a team' do
    sign_in users(:full_team_user_five)
    team = users(:full_team_user_five).team
    assert_difference 'team.users.reload.size', -1 do
      delete :destroy, params: { id: users(:full_team_user_five).id, user: { current_password: @password } }
    end
    assert :success
    assert_equal I18n.t("devise.registrations.destroyed"), flash[:notice]
  end

  test 'destroy user not on a team' do
    sign_in users(:user_three)
    assert_difference 'User.count', -1 do
      delete :destroy, params: { id: users(:user_three).id, user: { current_password: @password } }
    end
    assert :success
    assert_equal I18n.t("devise.registrations.destroyed"), flash[:notice]
  end

  test 'user unable to delete account without password' do
    sign_in users(:user_three)
    assert_no_difference 'User.count' do
      delete :destroy, params: { id: users(:user_three).id }
    end
    assert_equal I18n.t("devise.registrations.password_needed_destroy"), flash[:alert]
  end

  test 'cannot get new registration after game close' do
    game = games(:mitre_ctf_game)
    game.start = Time.now - 24.hours
    game.stop = Time.now - 23.hours
    game.save

    get :new
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('game.after_competition'), flash[:alert]
  end
end
