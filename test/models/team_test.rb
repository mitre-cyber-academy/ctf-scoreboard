require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test 'team with ineligible user is ineligible for prizes' do
    assert_equal(false, teams(:team_one).eligible_for_prizes?)
  end

  test 'team without team captain is automatically assigned to first user' do
    team = teams(:team_two)
    user = users(:user_three)
    team.users << user
    team.save
    assert_equal(user, team.team_captain)
  end

  test 'team with one eligible user and one ineligible is ineligible for prizes' do
    teams(:team_one).users << users(:user_two)
    assert_equal(false, teams(:team_one).eligible_for_prizes?)
  end

  test 'team with two eligible users is eligible for prizes' do
    teams(:team_one).users << users(:user_two)
    users(:user_one).compete_for_prizes = true
    assert_equal(false, teams(:team_one).eligible_for_prizes?)
  end

  test 'team is removed after last user leaves' do
  end

  test 'captain is promoted' do
  end
end
