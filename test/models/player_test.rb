require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test 'score method returns proper value' do
    team_one = users(:player_one)
    # Player 1 has a 200 point score adjustment added from the fixtures
    assert_equal 200, team_one.score
  end

  test 'display name' do
    # Eligible
    assert_equal users(:player_one).display_name, users(:player_one).display_name
    # Ineligible
    assert_equal users(:player_three).display_name, users(:player_three).display_name
  end

  test 'key file name' do
    key_phile_name = 'playeronete' + users(:player_one).id.to_s
    assert_equal key_phile_name, users(:player_one).key_file_name
  end
end