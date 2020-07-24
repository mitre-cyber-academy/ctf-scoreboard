require 'test_helper'

class SummaryDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:active_game)
  end

  test 'No teams show header shows on summary page when there are no teams' do
    get "/game/summary"
    Team.destroy_all
    assert_select 'h1', /Game Summary/, 'Game summary header should show on the game summary page'
    assert_select 'h4', /No Teams/, 'No teams should show when there are no teams on the game summary page'
  end

  test 'summary table displays correctly' do
    team = create(:team)
    sign_in create(:user)
    get "/game/summary"
    puts team.achievements
    assert_select 'table[class=table\ table-bordered\ table-striped\ table-hover]' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', '#'
          assert_select 'th:nth-child(2)', I18n.t('game.team_list.team_name')
          assert_select 'th:nth-child(3)', I18n.t('game.team_list.team_achievements')
          assert_select 'th:nth-child(4)', I18n.t('game.team_list.team_points')
        end
      end
      assert_select 'tbody' do
        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', '1'
          assert_select 'td:nth-child(2) a[href=\/teams\/' + team.id.to_s + '\/summary]'
          assert_select 'td:nth-child(3)', '0'
          assert_select 'td:nth-child(4)', '0'
        end
      end
    end
  end
end
