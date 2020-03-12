require 'test_helper'

class GameboardDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  test "jeopardy board with only point challenges displays correctly" do
    create(:active_game, board_layout: :jeopardy)
    # Challenges are displayed by their number of categories, and then sorted
    # down by point value
    chal1 = create(:standard_challenge, point_value: 100, category_count: 2)
    chal3 = create(:standard_challenge, point_value: 150, category_count: 1)
    chal2 = create(:standard_challenge, point_value: 100, category_count: 0, categories: chal3.categories)
    chal4 = create(:standard_challenge, point_value: 100, category_count: 0)

    get "/game"

    assert_select 'table#jeopardy-table' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', chal1.categories.map(&:name).join(', ')
          assert_select 'th:nth-child(2)', chal2.categories.map(&:name).join(', ')
          assert_select 'th:nth-child(3)', 'No Category'
        end
      end
      assert_select 'tbody' do
        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1) a[href=?]', game_challenge_path(chal1),
            {count: 1, text: chal1.point_value.to_s}
          assert_select 'td:nth-child(2) a[href=?]', game_challenge_path(chal2),
            {count: 1, text: chal2.point_value.to_s}
          assert_select 'td:nth-child(3) a[href=?]', game_challenge_path(chal4),
            {count: 1, text: chal4.point_value.to_s}
        end
        assert_select 'tr:nth-child(2)' do
          # This is a non-breaking space, not an actual space.
          # They look the same but must be copy-pasted to actually pass testing
          assert_select 'td:nth-child(1)', ' '
          assert_select 'td:nth-child(2) a[href=?]', game_challenge_path(chal3),
            {count: 1, text: chal3.point_value.to_s}
          # This is a non-breaking space, not an actual space.
          # They look the same but must be copy-pasted to actually pass testing
          assert_select 'td:nth-child(3)', ' '
        end
      end
    end
    assert_select "h3", {count: 0, text: "Attack Defense Challenges"}, "This page must not contain Attack Defense Challenge Text"
  end

  test "jeopardy board with pentest challenges displays correctly" do
    create(:active_game, board_layout: :jeopardy)
    # Challenges are displayed by their number of categories, and then sorted
    # down by point value
    create(:standard_challenge, point_value: 100, category_count: 2)
    point_chal = create(:standard_challenge, point_value: 150, category_count: 1)
    create(:standard_challenge, point_value: 100, category_count: 0, categories: point_chal.categories)
    create(:standard_challenge, point_value: 100, category_count: 0)

    team1 = create(:team)
    team2 = create(:team)

    chal1 = create(:pentest_challenge_with_flags, point_value: 500)
    chal2 = create(:pentest_challenge_with_flags, point_value: 400)
    chal3 = create(:pentest_challenge_with_flags, point_value: 300)

    team1_chal2_flag = chal2.defense_flags.find_by(team: team1)
    # This creates a solve for team1 against team2 on challenge #2
    create(:pentest_solved_challenge, challenge: chal2, team: team2, flag: team1_chal2_flag)

    get "/game"

    assert_select 'table#jeopardy-table', 1
    assert_select "h3", "Attack Defense Challenges", "This page must contain Attack Defense Challenge Text"
    assert_select 'table#pentest-table' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', 'Teams'
          assert_select 'th:nth-child(2)', chal1.name
          assert_select 'th:nth-child(3)', chal2.name
          assert_select 'th:nth-child(4)', chal3.name
        end
      end
      assert_select 'tbody' do
        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', display_name(team1)
          assert_select 'td:nth-child(2)', chal1.point_value.to_s
          assert_select 'td:nth-child(3)', (chal2.point_value / 2).to_s # Solved
          assert_select 'td:nth-child(4)', chal3.point_value.to_s
        end
        assert_select 'tr:nth-child(2)' do
          assert_select 'td:nth-child(1)', display_name(team2)
          assert_select 'td:nth-child(2)', chal1.point_value.to_s
          assert_select 'td:nth-child(3)', chal2.point_value.to_s # Solved
          assert_select 'td:nth-child(4)', chal3.point_value.to_s
        end
      end
    end
  end

  test "teams x challenges with only point challenges displays correctly no user logged in" do
    create(:active_game, board_layout: :teams_x_challenges)
    # Challenges for teams x challenges are displayed by their point value and then name
    chal1 = create(:standard_challenge, point_value: 100, category_count: 2)
    chal3 = create(:standard_challenge, name: 'c', point_value: 150, category_count: 1)
    chal2 = create(:standard_challenge, name: 'b', point_value: 150, category_count: 0, categories: chal3.categories)

    team1 = create(:team)
    team2 = create(:team)

    get "/game"

    assert_select 'table#teams-x-challenges-table' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', 'Teams'
          assert_select 'th:nth-child(2)', chal1.name
          assert_select 'th:nth-child(3)', chal2.name
          assert_select 'th:nth-child(4)', chal3.name
        end
      end
      assert_select 'tbody' do
        assert_select 'tr' do
          assert_select 'td:nth-child(1)', display_name(team1)
          assert_select 'td:nth-child(1)', display_name(team2)
          assert_select 'td', {count: 6, text: '-'}
        end
      end
    end
    assert_select "h3", {count: 0, text: "Attack Defense Challenges"}, "This page must not contain Attack Defense Challenge Text"
  end

  test "teams x challenges with only point challenges displays correctly team1 logged in" do
    create(:active_game, board_layout: :teams_x_challenges)
    # Challenges for teams x challenges are displayed by their point value and then name
    chal1 = create(:standard_challenge, point_value: 100, category_count: 2)
    chal3 = create(:standard_challenge, name: 'c', point_value: 150, category_count: 1)
    chal2 = create(:standard_challenge, name: 'b', point_value: 150, category_count: 0, categories: chal3.categories)

    team1 = create(:team)
    team2 = create(:team)

    create(:standard_solved_challenge, challenge: chal2, team: team1)

    sign_in team1.team_captain

    get "/game"

    assert_select 'table#teams-x-challenges-table' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', 'Teams'
          assert_select 'th:nth-child(2)', chal1.name
          assert_select 'th:nth-child(3)', chal2.name
          assert_select 'th:nth-child(4)', chal3.name
        end
      end
      assert_select 'tbody' do
        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', display_name(team1)
          assert_select 'td:nth-child(2)', 'Click to Solve'
          assert_select 'td:nth-child(3)', 'Solved'
          assert_select 'td:nth-child(4)', 'Click to Solve'
        end
        assert_select 'tr:nth-child(2)' do
          assert_select 'td:nth-child(1)', display_name(team2)
          assert_select 'td', {count: 3, text: '-'}
        end
      end
    end
  end

  test "teams x challenges displays correctly team2 logged in" do
    create(:active_game, board_layout: :teams_x_challenges)
    # Challenges for teams x challenges are displayed by their point value and then name
    chal1 = create(:standard_challenge, point_value: 100, category_count: 2)
    chal3 = create(:standard_challenge, name: 'c', point_value: 150, category_count: 1)
    chal2 = create(:standard_challenge, name: 'b', point_value: 150, category_count: 0, categories: chal3.categories)

    team1 = create(:team)
    team2 = create(:team)

    create(:standard_solved_challenge, challenge: chal2, team: team1)

    sign_in team2.team_captain

    get "/game"

    assert_select 'table#teams-x-challenges-table' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', 'Teams'
          assert_select 'th:nth-child(2)', chal1.name
          assert_select 'th:nth-child(3)', chal2.name
          assert_select 'th:nth-child(4)', chal3.name
        end
      end
      assert_select 'tbody' do
        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', display_name(team1)
          assert_select 'td', {count: 2, text: '-'}
          assert_select 'td:nth-child(3)', 'Solved'

        end
        assert_select 'tr:nth-child(2)' do
          assert_select 'td:nth-child(1)', display_name(team2)
          assert_select 'td:nth-child(n+2)', {count: 3, text: 'Click to Solve'}
        end
      end
    end
  end
end
