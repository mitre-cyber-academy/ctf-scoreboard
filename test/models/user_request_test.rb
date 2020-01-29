require 'test_helper'

class UserRequestTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_jeopardy_game)
    @team = create(:point_team, additional_member_count: 1)
    @user = create(:user)
  end

  test 'uniqueness of pending request' do
    create(:point_user_request, team: @team, user: @user)
    user_request = build(:point_user_request, team: @team, user: @user)
    assert !user_request.valid?
    assert_equal true, user_request.errors.added?(:user, 'already has a pending request for this team.')
  end

  test 'user on a team' do
    user_request = create(:point_user_request, team: @team, user: @user)
    assert_equal false, user_request.user_on_team?
  end

  test 'accept a request' do
    user_request = create(:point_user_request, team: @team, user: @user)
    assert_difference '@team.users.reload.size', +1 do
      user_request.accept
    end
  end

  test 'accept full team request' do
    team = create(:point_team, additional_member_count: @game.team_size - 1)
    user_request = create(:point_user_request, team: team, user: @user)
    assert_no_difference 'team.users.reload.size' do
      user_request.accept
    end
  end

  test 'accept request from user on a team' do
    non_captain = @team.users.where.not(id: @team.team_captain).first
    user_request = create(:point_user_request, team: @team, user: non_captain)
    assert_no_difference '@team.users.reload.size' do
      user_request.accept
    end
  end
end
