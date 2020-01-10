require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  def setup
    create(:active_game)
  end

  test 'index' do
    get :index
    assert_response :success
  end
end
