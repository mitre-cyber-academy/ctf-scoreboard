require 'test_helper'

class UserDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:active_game, employment_opportunities_available: true)
  end

  test 'team creation header shows when visiting team creation page' do
    sign_in create(:user)
    get "/users/edit"

    assert_select 'h1', /Edit Account/
  end

  test 'ensure that interested in employment is absent when employment opportunities are not available' do
    @game.update(employment_opportunities_available: false)

    sign_in create(:user)
    get "/users/edit"

    assert_select 'label', {count: 0, text: 'Interested in employment'}
  end

  test 'ensure that there is a edit and delete form on the user edit page' do
    sign_in create(:user)
    get "/users/edit"

    assert_select 'form[id=user-form]' do
      assert_select 'label', 'Full name'
      assert_select 'label', 'Email'
      assert_select 'label', 'Affiliation'
      assert_select 'label', 'Year in school'
      assert_select 'label', 'State'
      assert_select 'label', 'Password'
      assert_select 'label', 'Confirm Password'
      assert_select 'label', 'Compete for prizes'
      assert_select 'label', 'Interested in employment'
      assert_select 'label', 'Major/Area of study'
      assert_select 'label', 'Current password'
    end

    assert_select 'form[id=delete-user-form]' do
      assert_select 'label', 'Delete account'
    end
  end
end
