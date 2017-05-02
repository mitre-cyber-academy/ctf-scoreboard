require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'index' do
    sign_in users(:user_one)
    # Render
    get :index
    assert :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get submit_flag" do
    get :submit_flag
    assert_response :success
  end

  test "should get find_challenge" do
    get :find_challenge
    assert_response :success
  end

  test 'submit correct flag' do
  end

  test 'submit incorrect flag' do
  end
end
