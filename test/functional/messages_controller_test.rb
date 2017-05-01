require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'index' do
    sign_in users(:player_one)
    get :index
    assert :success
  end

  test 'users messages are updated' do
  end
end
