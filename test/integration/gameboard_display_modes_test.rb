require 'test_helper'

class GameboardDisplayModesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "jeopardy board with only point challenges displays correctly" do
    create(:active_game, board_layout: :jeopardy)
    create(:point_challenge, point_value: 100, category_count: 0)

    get "/game"
    # TODO: Validate the whole table looks right here, something like
    # assert_select 'table' do
    #   assert_select 'tr#permission_1' do
    #     assert_select 'td:nth-child(1)', 'test user01'
    #     assert_select 'td:nth-child(2)', 'Reading permission'
    #   end
    # end
    assert_select "h3", {count: 0, text: "Attack Defense Challenges"}, "This page must not contain Attack Defense Challenge Text"
  end
end
