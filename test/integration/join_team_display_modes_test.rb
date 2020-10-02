require 'test_helper'

class JoinTeamDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  test "join teams page table displays correctly" do
    game = create(:active_game, board_layout: :jeopardy)
    user = create(:user)
    sign_in user
    Team.destroy_all
    create_list(:team, 10, compete_for_prizes: true)
    get join_team_users_path
    assert_response :success
    assert_select 'table.table.table-hover.table-bordered' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th', I18n.t('users.join_team.teams_table.name_header'), "Name table header missing from Join Team table"
          assert_select 'th', I18n.t('users.join_team.teams_table.affiliation_header'), "Affiliation table header missing from Join Team table"
          assert_select 'th', I18n.t('users.join_team.teams_table.spots_header'), "Spots Available table header missing from Join Team table"
          assert_select 'th', I18n.t('users.join_team.teams_table.division_header'), "Division table header missing from Join Team table"
          assert_select 'th', I18n.t('users.join_team.teams_table.request_join_header'), "Request to Join table header missing from Join Team table"
        end
      end
      assert_select 'tbody' do
        Team.all.each do |t|
          assert_select 'tr' do
            assert_select 'td', "#{t.team_name}", "Team's name missing from join teams table"
            assert_select 'td', "#{t.affiliation}", "Team's affiliation missing from join teams table"
            assert_select 'td', "#{t.slots_available}", "Team's number of slots available missing from join team's table"
            assert_select 'td', "#{t.division.name}", "Team's division name is missing from join team's table"
          end
        end
      end
    end
  end

  test "teams looking for members display on join teams page table" do
    game = create(:active_game, board_layout: :jeopardy)
    user = create(:user)
    sign_in user
    Team.destroy_all
    create(:team, compete_for_prizes: true, looking_for_members: true)
    get join_team_users_path
    assert_response :success
    assert_select 'tbody' do
      Team.all.each do |t|
        assert_select 'tr' do
          assert_select 'td', "#{t.team_name}", "Team's name missing from join teams table"
          assert_select 'td', "#{t.affiliation}", "Team's affiliation missing from join teams table"
          assert_select 'td', "#{t.slots_available}", "Team's number of slots available missing from join team's table"
          assert_select 'td', "#{t.division.name}", "Team's division name is missing from join team's table"
        end
      end
    end
  end

  test "teams not looking for members do not display on the join teams table" do
    game = create(:active_game, board_layout: :jeopardy)
    user = create(:user)
    sign_in user
    Team.destroy_all
    create(:team, compete_for_prizes: true, looking_for_members: false)
    get join_team_users_path
    assert_response :success
    assert_select 'tbody' do
      Team.all.each do |t|
        assert_select 'tr', {:count=>0}, "Team's row displays on join teams table when team is not looking for members"
      end
    end
  end
end
