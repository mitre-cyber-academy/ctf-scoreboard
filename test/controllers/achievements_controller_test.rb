require 'test_helper'

class AchievementsControllerTest < ActionController::TestCase
  def setup
    @game = create(:active_point_game)
  end

  test 'can access achievements index' do
    get :index
    assert_response :success
  end
end
