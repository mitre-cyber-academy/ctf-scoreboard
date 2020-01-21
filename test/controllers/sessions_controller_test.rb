# frozen_string_literal: true
require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = create(:user)
  end

  test 'new user sessions' do
    get :new
    assert_response :success
  end

  test 'create user sessions' do
    get :create
    assert_response :redirect
  end

  test 'destroy user sessions' do
    sign_in @user
    delete :destroy
    assert_response :redirect
  end
end
