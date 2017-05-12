require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase
  include ChallengesHelper

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'should get show' do
    sign_in users(:user_one)
    get :show, params: {
      id: challenges(:challenge_one_cat_one)
    }
    assert_response :success
  end

  test 'submit correct flag' do
    sign_in users(:user_one)
    put :update, params: {
      id: challenges(:challenge_one_cat_one),
      challenge: {
        submitted_flag: flags(:flag_one).flag
      }
    }
    assert :success
    assert_equal flash[:notice], I18n.t('flag.accepted')
  end

  test 'submit incorrect flag' do
    sign_in users(:user_one)
    put :update, params: {
      id: challenges(:challenge_one_cat_one),
      challenge: {
        submitted_flag: "wrong"
      }
    }
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  # Private methods
  test 'should get find_challenge' do
  end

  test 'should find and log flag' do
  end
end
