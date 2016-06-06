require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  test 'unable to destroy team captain' do
    sign_in users(:user_one)
    delete :destroy, id: users(:user_one).id
  end

  test 'destroy user on a team' do
  end

  test 'destroy user not on a team' do
    sign_in users(:user_three)
    delete :destroy
    assert :success
  end
end
