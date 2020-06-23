require 'test_helper'

class GameboardDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  test "registration blocked when registration closed" do
    create(:active_game, board_layout: :jeopardy, registration_enabled: false)
    
    get "/users/new"
    assert_response :redirect
  end
end
