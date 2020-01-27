require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test 'should get index when game has been created' do
    create(:active_jeopardy_game)

    get :index
    assert_response :success
  end

  test 'should get redirected to login when no game has been created' do
    get :index
    assert_response :redirect
    assert_equal flash[:alert], I18n.t('game.must_be_admin')
  end

  test 'should get redirected to create a game when logged in as admin and no game has been created' do
    sign_in create(:admin)
    get :index
    assert_response :redirect
    assert_redirected_to @controller.rails_admin.new_path('game')
  end
end
