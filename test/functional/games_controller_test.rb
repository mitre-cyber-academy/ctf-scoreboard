require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'index' do
  end

  test 'show' do
  end

  test 'summary' do
  end
end
