require 'test_helper'

class ChallengeDisplayModesTest < ActionDispatch::IntegrationTest
    include TeamsHelper
    include Devise::Test::IntegrationHelpers

    test "sponsor exists on challenge page" do
        game = create(:active_game, board_layout: :jeopardy)
        # Challenges are displayed by their number of categories, and then sorted
        # down by point value
        challenge1 = create(:standard_challenge,
            sponsored: true,
            sponsor: 'MITRE',
            sponsor_logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Mitre_Corporation_logo.svg/220px-Mitre_Corporation_logo.svg.png',
            sponsor_description: 'The Mitre Corporation is an American not-for-profit organization based in Bedford, Massachusetts, and McLean, Virginia.'
        )
        team = create(:team)
        sign_in team.team_captain

        get "/game/challenges/#{challenge1.id}"

        assert_select 'div#sponsorInfo' do
            assert_select 'h3', 'Sponsor'
            assert_select 'img' do
                assert_select '[src=?]', challenge1.sponsor_logo
            end
            assert_select 'p', challenge1.sponsor_description
        end
    end
end
