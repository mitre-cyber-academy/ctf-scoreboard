require 'test_helper'

class PointDivisionTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_game)
    @division = @game.divisions.first
    create_list(:team, 10, division: @division)
    create_list(:team, 10, division: @division, compete_for_prizes: true)
  end
  test 'sort all players and ensure both lists are the same length' do
    ordered_teams = @division.ordered_teams
    assert_equal @division.teams.size, ordered_teams.size

    # All the indexes of teams who are eligible should be to the left of indexes of ineligible teams
    eligible_team_locations = ordered_teams.collect(&:eligible)
    assert eligible_team_locations.index(true) < eligible_team_locations.index(false)
  end

  test 'top five eligible players' do
    ordered_teams = @division.ordered_teams(true)
    assert_operator 5, :>=, ordered_teams.size
  end
end
