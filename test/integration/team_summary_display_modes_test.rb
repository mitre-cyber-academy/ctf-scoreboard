require 'test_helper'

class TeamSummaryDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  test "test bullet discovers n+1 query on summary page" do
    create(:active_game, board_layout: :jeopardy)
    team = create(:team)

    chal1 = create(:standard_challenge, point_value: 100, category_count: 2)
    chal2 = create(:standard_challenge, point_value: 100, category_count: 0)
    chal3 = create(:standard_challenge, point_value: 150, category_count: 1)
    chal4 = create(:standard_challenge, point_value: 100, category_count: 0)
    chal5 = create(:standard_challenge, point_value: 100, category_count: 0)

    solved_chal1 = create(:standard_solved_challenge, team: team, challenge: chal1)
    solved_chal2 = create(:standard_solved_challenge, team: team, challenge: chal2)
    solved_chal3 = create(:standard_solved_challenge, team: team, challenge: chal3)
    solved_chal4 = create(:standard_solved_challenge, team: team, challenge: chal4)
    solved_chal5 = create(:standard_solved_challenge, team: team, challenge: chal5)
    
    captain = team.team_captain

    sign_in captain

    get "/teams/#{team.id}/summary"

  end
end
