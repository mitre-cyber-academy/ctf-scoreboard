require 'test_helper'

class UserDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:active_game)
  end

  test 'user edit page' do
    sign_in create(:user)
    get "/users/edit"

    assert_select 'h1', /Edit Account/, 'Edit account should show on the edit user page'
    assert_select 'form[id=edit_user]' do
      assert_select 'label', 'Full name'
      assert_select 'label', 'Email'
      assert_select 'label', 'Affiliation'
      assert_select 'label', 'Year in school'
      assert_select 'label', 'State'
      assert_select 'label', 'Password'
      assert_select 'label', 'Confirm Password'
      assert_select 'label', 'Compete for prizes'
      assert_select 'label', 'Interested in employment'
      assert_select 'label', 'Age'
      assert_select 'label', 'Major/Area of study'
      assert_select 'label', 'Resume'
      assert_select 'label', 'Unofficial transcript'
      assert_select 'label', 'Current password'
    end
  end
end