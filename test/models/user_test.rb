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
    user = create(:user, year_in_school: 12, country: 'UK', compete_for_prizes: true)
    assert_equal(false, user.compete_for_prizes)
  end

  test 'user previously not in the US can compete for prizes' do
    user = create(:user, year_in_school: 12, country: 'UK', compete_for_prizes: false)
    user.update(country: 'US', compete_for_prizes: true)
    assert_equal(true, user.compete_for_prizes)
  end

  test 'user state is nil if country is outside US' do
    user = create(:user, country: 'AF', state: 'FL')
    user.save
    assert_nil(user.state)
  end

  test 'user will not save if they do not accept age requirement' do
    user = build(:user, age_requirement_accepted: false)
    assert_equal(false, user.save)
    assert_equal true, user.errors.added?(:age_requirement_accepted, 'can\'t be blank')
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

  test 'link to invitiations' do
    team = create(:team)
    invite = create(:point_user_invite, team: team)
    user = create(:user, email: invite.email)
    invite.reload
    assert_equal user, invite.user
  end
end
