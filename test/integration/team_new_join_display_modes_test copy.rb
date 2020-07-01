require 'test_helper'

class TeamNewJoinDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:active_game)
  end

  test 'team creation header shows when visiting team creation page' do
    sign_in create(:user)
    get "/teams/new"

    assert_select 'h1', /Create a Team/
  end

  test 'ensure that there is a form on the team creation page' do
    sign_in create(:user)
    get "/teams/new"

    assert_select 'form[id=new_team]' do
      assert_select 'label:nth-child(1)', 'Team name'
      assert_select 'label:nth-child(1)', 'Affiliation'
      assert_select 'label:nth-child(1)', 'Division'
    end
  end

  test 'join team header shows when visiting team join page' do
    sign_in create(:user)
    get "/users/join_team"
    assert_response :success
    assert_select 'h1', /Join a Team/
  end

  test 'ensure the form is shown correctly on join team page' do
    sign_in create(:user)
    get "/users/join_team"

    assert_select 'form[id=filterrific_filter]' do
      assert_select 'div[class=row]' do
        assert_select 'div:nth-child(1)', /Team Name/
        assert_select 'div:nth-child(2)', /Affiliation/
        assert_select 'div:nth-child(3)', /Location/
        assert_select 'div:nth-child(4)', /Division/
      end
    end
  end
end
