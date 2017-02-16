require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
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

end
