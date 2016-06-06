require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'unable to destroy team captain' do
    sign_in users(:user_one)
    delete :destroy, id: users(:user_one).id
    assert :success
    assert_equal I18n.t("devise.registrations.captain_tried_to_destroy"), flash[:alert]
  end

  test 'destroy user on a team' do
    sign_in users(:full_team_user_five)
    delete :destroy, id: users(:full_team_user_five).id
    assert :success
    # assert_equal I18n.t("devise.registrations.destroyed"), flash[:notice]
  end

  test 'destroy user not on a team' do
    sign_in users(:user_three)
    delete :destroy, id: users(:user_three).id
    assert :success
    # assert_equal I18n.t("devise.registrations.destroyed"), flash[:notice]
  end
end
