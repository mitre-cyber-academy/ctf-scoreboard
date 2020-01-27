require 'test_helper'

class TeamsHelperTest < ActionView::TestCase

  def setup
    create(:active_jeopardy_game)
  end

  test 'display name ineligible' do
    team = create(:team)
    assert_includes display_name(team), '(ineligible)'
  end

  test 'display name eligible' do
    team = create(:team)
    team.team_captain.update(compete_for_prizes: true)
    team.reload
    assert_equal team.team_name, display_name(team)
  end
end
