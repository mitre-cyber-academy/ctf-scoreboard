require "test_helper"

class PagesControllerTest < ActionController::TestCase

  def setup
    create(:active_game)
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
