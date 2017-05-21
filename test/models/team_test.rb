require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  test 'team without team captain is automatically assigned to first user' do
    team = teams(:team_two)
    user = users(:user_three)
    team.users << user
    team.save
    assert_equal(user, team.team_captain)
  end

  test 'high school team with two high school students is allowed' do
    teams(:team_one).users << users(:full_team_user_one)
    assert_equal(true, teams(:team_one).appropriate_division_level?)
  end

  test 'high school team with one high school and one college student is not allowed' do
    teams(:team_one).users << users(:user_three)
    assert_equal(false, teams(:team_one).appropriate_division_level?)
  end

  test 'professional team with one professional is allowed' do
    assert_equal(true, teams(:team_three).appropriate_division_level?)
  end

  test 'team with profanity will not save' do
    @team = Team.new(team_name: 'hell', affiliation: 'hell')
    assert_equal(false, @team.save)
  end

  test 'deleting a team will not leave any orphaned invites or requests' do
    teams(:team_one).destroy
    # Get all user invites and requests where the associated team no longer exists. The call to compact
    # is in order to get rid of the nil's that the collect method leaves in for teams which are not nil.
    orphaned_invites = UserInvite.all.collect{ |user_invite| user_invite if user_invite.team.nil? }.compact
    orphaned_requests = UserRequest.all.collect{ |user_request| user_request if user_request.team.nil? }.compact
    assert_equal 0, orphaned_invites.count
    assert_equal 0, orphaned_requests.count
  end

  test 'promote' do
    # These users are on the same team!
    team = users(:full_team_user_one).team
    team.promote(users(:full_team_user_five))
    assert_equal team.team_captain, users(:full_team_user_five)
  end

  test 'promote a user that is not on the same team' do
    # These users are not on the same team!
    team = users(:user_one).team
    team.promote(users(:full_team_user_five))
    assert_not_equal team.team_captain, users(:full_team_user_five)
  end

  test 'score method returns proper value' do
    team_one = teams(:team_one)
    # Team 1 has a 200 point score adjustment added from the fixtures
    assert_equal 200, team_one.score
  end

  test 'display name' do
    # Eligible
    assert_equal teams(:team_one).display_name, teams(:team_one).display_name
    # Ineligible
    assert_equal teams(:team_three).display_name, teams(:team_three).display_name
  end
end
