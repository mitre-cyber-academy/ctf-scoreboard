require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  # TODO: Ensure that no errors show up on the registraton page when upon intiial navigation
  # (This happens if check_captcha is run on new and create for example)

  def setup
    create(:active_game)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @password = 'TestPassword123'
  end

  test 'unable to destroy team captain' do
    user_team_captain = create(:user_with_team)
    sign_in user_team_captain
    delete :destroy, params: { id: user_team_captain.id }
    assert :success
    assert_equal I18n.t("devise.registrations.captain_tried_to_destroy"), flash[:alert]
  end

  test 'destroy user on a team' do
    @team = create(:team)
    @user_not_captain = create(:user, password: @password, team: @team)
    sign_in @user_not_captain

    assert_difference '@team.users.reload.count', -1 do
      delete :destroy, params: { id: @user_not_captain.id, user: { current_password: @password } }
    end
    assert :success
    assert_equal I18n.t("devise.registrations.destroyed"), flash[:notice]
  end

  test 'destroy user not on a team' do
    @user = create(:user, password: @password)
    sign_in @user
    assert_difference 'User.count', -1 do
      delete :destroy, params: { id: @user.id, user: { current_password: @password } }
    end
    assert :success
    assert_equal I18n.t("devise.registrations.destroyed"), flash[:notice]
  end

  test 'user unable to delete account without password' do
    @user = create(:user)
    sign_in @user
    assert_no_difference 'User.count' do
      delete :destroy, params: { id: @user.id }
    end
    assert_equal I18n.t("devise.registrations.password_needed_destroy"), flash[:alert]
  end

  test 'cannot get new registration after game close' do
    game = create(:ended_game)

    get :new
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('game.after_competition'), flash[:alert]
  end

  test 'new' do
    get :new
    assert :success
    # Could look for the HTML elements but not really testing any custom controller actions...
  end

  test 'create' do
    user = build(:user)
    post :create, params: { user: build_user_params(user) }
    assert :redirect
  end

  test 'create with failed recaptcha' do
    create(:active_game)
    Recaptcha.configuration.skip_verify_env.delete('test')
    Recaptcha.configure do |config|
      config.site_key = 'whatever'
      config.secret_key = 'whatever'
    end
    user = build(:user)
    post :create, params: { user: build_user_params(user) }
    assert_response :success
    assert_equal flash['alert'], I18n.t('devise.registrations.recaptcha_failed')
    Recaptcha.configuration.skip_verify_env << 'test'
  end
end
