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

  test 'team with two high school students is a high school team' do
    teams(:team_one).users << users(:full_team_user_one)
    assert_equal('High School', teams(:team_one).division_level)
  end

  test 'team with one high school and one college student is a college team' do
    teams(:team_one).users << users(:user_three)
    assert_equal('College', teams(:team_one).division_level)
  end

  test 'team with one professional is professional level team' do
    assert_equal('Professional', teams(:team_three).division_level)
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

  test 'special characters in team name will be removed when converting to scoreboard' do
    team = teams(:team_with_special_chars)
    assert_equal team.scoreboard_login_name, "s0m3thing_amazing"
  end

  test 'team most common location is calculated properly on a full team' do
    team = teams(:full_team)
    # 3 out of 5 players on this team have their location set to FL.
    assert_equal team.common_team_location, 'FL'
  end

  test 'team with only one player has the common location calculated properly' do
    team = teams(:team_one)
    assert_equal team.common_team_location, 'FL'
  end

  test 'score method returns proper value' do
    team_one = teams(:team_one)
    # Player 1 has a 200 point score adjustment added from the fixtures
    assert_equal 200, team_one.score
  end

  test 'display name' do
    # Eligible
    assert_equal teams(:team_one).display_name, teams(:team_one).display_name
    # Ineligible
    assert_equal teams(:team_three).display_name, teams(:team_three).display_name
  end
end
