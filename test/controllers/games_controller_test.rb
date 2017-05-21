require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'index' do
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get summary" do
    get :summary
    assert_response :success
  end

  test 'should not get summary when game is not open' do
    game = games(:mitre_ctf_game)
    game.start = Time.now + 9.hours
    game.save

    get :summary
    assert_redirected_to @controller.user_root_path
    assert_equal flash[:alert], I18n.t('game.not_available')
  end
end
