require 'test_helper'

class UserRequestsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"] = 'http://test.com/'
  end

  test 'create request' do
  end

  test 'accept request' do
  end

  test 'destroy request' do
  end
end
