require 'test_helper'

class ConfirmationsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'get user confirmation' do
    get :new
    assert_response :redirect
    get :show
    assert_response :redirect
  end
end
