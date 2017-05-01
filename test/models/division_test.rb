require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  test 'all eligible players' do
    ordered_players = divisions(:division_one).ordered_players
    assert_equal divisions(:division_one).players.size, ordered_players.size
  end

  test 'top five eligible players' do
    ordered_players = divisions(:division_one).ordered_players(true)
    assert_operator 5, :>=, ordered_players.size
  end
end
