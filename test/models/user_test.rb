require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    create(:active_game)
  end

  test 'default compete for prizes value is false if none is provided' do
    user = create(:user)
    assert_equal(false, user.compete_for_prizes)
  end

  test 'user must be in school to compete for prizes' do
    user = create(:user, year_in_school: 0, compete_for_prizes: true)
    assert_equal(false, user.compete_for_prizes)
  end

  test 'user must be in the US to compete for prizes' do
    user = create(:user, year_in_school: 12, state: 'NA', compete_for_prizes: true)
    assert_equal(false, user.compete_for_prizes)
  end

  test 'user previously not in the US can compete for prizes' do
    user = create(:user, year_in_school: 12, state: 'NA', compete_for_prizes: false)
    user.update(state: 'FL', compete_for_prizes: true)
    assert_equal(true, user.compete_for_prizes)
  end

  test 'user is a team captain' do
    team = create(:team, additional_member_count: 1)
    captain = team.team_captain
    non_captain = team.users.where.not(id: captain).first
    assert_equal(true, captain.team_captain?)
    assert_equal(false, non_captain.team_captain?)
  end

  test 'user can promote a team captain if they are currently captain' do
    team = create(:team, additional_member_count: 1)
    captain = team.team_captain
    non_captain = team.users.where.not(id: captain).first
    assert_equal(true, captain.can_promote?(non_captain))
  end

  test 'team captain cannot promote themselves team captain' do
    team = create(:team, additional_member_count: 2)
    captain = team.team_captain
    assert_equal(false, captain.can_promote?(captain))
  end

  test 'non team captain cannot promote a team captain' do
    team = create(:team, additional_member_count: 2)
    captain = team.team_captain
    player_list = team.users.where.not(id: captain)
    assert_equal(false, player_list.first.can_promote?(player_list.last))
  end

  test 'team captain can remove themselves from a team' do
    team = create(:team, additional_member_count: 2)
    captain = team.team_captain
    assert_equal(true, captain.can_remove?(captain))
  end

  test 'team captain can remove a member from his team' do
    team = create(:team, additional_member_count: 2)
    captain = team.team_captain
    assert_equal(true, captain.can_remove?(captain))
    non_captain = team.users.where.not(id: captain).first
    assert_equal(true, captain.can_remove?(non_captain))
  end

  test 'user can remove themselves from a team' do
    team = create(:team, additional_member_count: 1)
    captain = team.team_captain
    non_captain = team.users.where.not(id: captain).first
    assert_equal(true, non_captain.can_remove?(non_captain))
  end

  test 'non team captain cannot remove another user from a team' do
    team = create(:team, additional_member_count: 2)
    captain = team.team_captain
    player_list = team.users.where.not(id: captain)
    assert_equal(false, player_list.first.can_remove?(player_list.last))
  end

  stubs = [
    {'country' => 'USA', 'country_code' => 'US'},
    {'country' => 'RSA', 'country_code' => 'ZA'},
    {'country' => 'PRC', 'country_code' => 'CN'},
    {'country' => 'ROC', 'country_code' => 'TW'}
  ]

  countries = [
    'United States',
    'South Africa',
    'China',
    'Taiwan'
  ]

  stubs.each_with_index do |stub, idx|
    Geocoder::Lookup::Test.reset
    test "users country is calculated on save #{stub['country_code']}" do
      Geocoder::Lookup::Test.set_default_stub([stub])
      user = build(:user, current_sign_in_ip: Faker::Internet.public_ip_v4_address)
      user.save
      assert user.geocoded?
      assert_equal countries[idx], user.country
    end
    Geocoder::Lookup::Test.reset
  end

  test 'transform replaces bad characters' do
    assert_equal 'abcs_123_', (ApplicationRecord.transform'@Bc$_#123!%^&*()] [/\\')
  end
end
