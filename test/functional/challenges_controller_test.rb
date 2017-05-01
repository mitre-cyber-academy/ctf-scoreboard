require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'index' do
    sign_in users(:player_one)
    # Render
    get :index
    assert :success
  end

  test 'show' do
  end

  test 'submit correct flag' do
  end

  test 'submit incorrect flag' do
  end
end
