require 'test_helper'

class AchievementsControllerTest < ActionController::TestCase

  test 'index' do
    get :index
    assert_response :success
  end
end
