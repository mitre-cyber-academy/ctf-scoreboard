require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_game)
  end

  test 'creating a new team sets the team captain as a user' do
    team = create(:team)
    assert_equal team.users.first, team.team_captain
    team.users.delete(team.team_captain)
    team.save
    assert_equal team.users.first, team.team_captain
  end

  test 'deleting the last user on a team deletes the team' do
    team = create(:team)
    User.destroy(team.team_captain.id)
    assert Team.all.blank?
  end

  test 'no team captain will promote the first user' do
    team = create(:team, additional_member_count: 1)
    captain_to_be = team.users.reject { |user| !user.eql? team.team_captain }
    team.team_captain = nil
    team.save(validate: false)
    assert_includes captain_to_be, team.team_captain
  end

  test 'high school team with two high school students is allowed' do
    hs_division = create(:hs_division)
    captain = create(:user, year_in_school: 9)
    team = create(:team, team_captain: captain, division: hs_division)
    team.users << create(:user, year_in_school: 9)

    assert_equal(true, team.appropriate_division_level?)
  end

  test 'high school team with one high school and one college student is not allowed' do
    hs_division = create(:hs_division)
    captain = create(:user, year_in_school: 9)
    team = create(:team, team_captain: captain, division: hs_division)
    team.users << create(:user, year_in_school: 13)
    assert_equal(false, team.appropriate_division_level?)
  end

  test 'professional team with one professional is allowed' do
    professional_division = create(:division)
    captain = create(:user, year_in_school: 0)
    team = create(:team, team_captain: captain, division: professional_division)
    assert_equal(true, team.appropriate_division_level?)
  end

  test 'team with profanity will not save' do
    @team = build(:team, team_name: 'hell', affiliation: 'hell')
    assert_equal(false, @team.save)
  end

  test 'deleting a team will not leave any orphaned invites or requests' do
    team = create(:team)
    create(:point_user_invite, email: 'mitrectf+user2@gmail.com', team: team)
    create(:point_user_request, team: team, user: create(:user))
    team.destroy
    # Get all user invites and requests where the associated team no longer exists. The call to compact
    # is in order to get rid of the nil's that the collect method leaves in for teams which are not nil.
    orphaned_invites = UserInvite.all.collect{ |user_invite| user_invite if user_invite.team.nil? }.compact
    orphaned_requests = UserRequest.all.collect{ |user_request| user_request if user_request.team.nil? }.compact
    assert_equal 0, orphaned_invites.count
    assert_equal 0, orphaned_requests.count
  end

  test 'promoting a new captain is successful' do
    # This user is already on the team
    team = create(:team, additional_member_count: 1)
    non_captain = team.users.where.not(id: team.team_captain).first
    team.promote(non_captain)
    assert_equal team.team_captain, non_captain
  end

  test 'promote a user that is not on the same team' do
    # These users are not on the same team!
    team = create(:team)
    user_to_promote = create(:user)
    team.promote(user_to_promote)
    assert_not_equal team.team_captain, user_to_promote
  end

  test 'in top ten' do
    # Make sure to test with and without a solved challenge attached to a team
    team = create(:team_in_top_ten_standard_challenges)
    assert_equal true, team.in_top_ten?, 'Team with solved challenge and in first place is not in top ten'

    team2 = create(:team)
    assert_equal false, team2.in_top_ten?, "Team is in top ten when it hasn't solved a challenge"
  end

  test 'filter affiliation' do
    team = create(:team)
    results = Team.filter_affiliation(team.affiliation)
    assert_equal results.first, team
  end

  test 'filter location' do
    team = create(:team)
    results = Team.location(team.users.first.state)
    assert_equal results.first, team
  end

  test 'filter division' do
    team = create(:team)
    results = Team.division(team.division_id)
    assert_equal results.first, team
  end

  test 'filter team name' do
    team = create(:team)
    results = Team.filter_team_name(team.team_name)
    assert_equal results.first, team
  end

  test 'find rank' do
    team = create(:team)
    assert_equal 1, team.find_rank
  end

  test 'full?' do
    team = create(:team)
    assert_not team.full?
  end

  test 'score with team in a point division' do
    team = create(:team)
    challenge = create(:standard_challenge, categories: [@game.categories.first])
    create(:standard_solved_challenge, team: team, challenge: challenge)
    assert_equal challenge.point_value, team.score
  end

  test 'cannot create team if location_required is true but no location is given' do
    @game = create(:active_game, location_required: true)
    assert_raises(ActiveRecord::RecordInvalid) {
      team = create(:team)
      assert_contains team.errors, "Team location can't be blank"
    }
  end

  test 'create team with location' do
    team = create(:team, team_location: 'earth')
    assert_equal team.team_location, 'earth'
  end
end
