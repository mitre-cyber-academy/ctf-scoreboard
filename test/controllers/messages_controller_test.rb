require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'index' do
    get :index
    assert_response :success
  end
end
