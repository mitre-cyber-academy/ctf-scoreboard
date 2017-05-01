require 'test_helper'

class ChallengeStateTest < ActiveSupport::TestCase
  test 'default values' do
    # 1 == forced-closed
    assert_equal 'force_closed', challenge_states(:challenge_state_two_d2).default_values
    assert_equal 'open', challenge_states(:challenge_state_four_d2).default_values
  end
end