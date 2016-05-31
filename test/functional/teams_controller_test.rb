require 'test_helper'

class TeamsControllerTest < ActionController::TestCase

  test "unauthenticated users should not be able to access new team page" do
    get :new
    assert_redirected_to root_path
  end

end
