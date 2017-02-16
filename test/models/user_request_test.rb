require 'test_helper'

class UserRequestTest < ActiveSupport::TestCase

  test 'uniqueness of pending request' do
    user_request = UserRequest.new(
        team: teams(:team_one),
        user: users(:user_two)
    )
    assert !user_request.valid?
    assert_equal true, user_request.errors.added?(:user, 'already has a pending request for this team.')
  end

  test 'user on a team' do
    assert_equal false, user_requests(:request_one).user_on_team?
  end

  test 'accept a request' do
    team = users(:user_one).team
    assert_difference 'team.users.reload.size', +1 do
      user_requests(:request_one).accept
    end
  end

  test 'accept full team request' do
    team = users(:full_team_user_one).team
    assert_no_difference 'team.users.reload.size' do
      user_requests(:request_two).accept
    end
  end

  test 'accept request from user on a team' do
    team = users(:user_one).team
    assert_no_difference 'team.users.reload.size' do
      user_requests(:request_three).accept
    end
  end
end
