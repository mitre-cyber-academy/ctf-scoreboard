require 'test_helper'

class AchievementDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:active_game)
  end

  test 'achievement header shows on achievement page' do
    sign_in create(:user)
    get "/game/achievements"

    assert_select 'h1', /Achievements/
  end

  test 'no achievement shows when there are no achievement' do
    sign_in create(:user)
    get "/game/achievements"
    assert_select 'h4', /No achievements have been awarded/
  end

  test 'achievements display correctly' do
    achievement = create(:achievement, team: create(:team), text: 'Example Achievement')
    sign_in create(:user)
    get "/game/achievements"

    assert_select 'table[class=table\ table-bordered\ table-striped\ table-hover]' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', I18n.t('achievements.index.table_header_achievement_name')
          assert_select 'th:nth-child(2)', I18n.t('achievements.index.table_header_unlocked_by')
          assert_select 'th:nth-child(3)', I18n.t('achievements.index.table_header_when')
        end
      end
      assert_select 'tbody' do
        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', achievement.text
          assert_select 'td:nth-child(2) a[href=\/teams\/' + achievement.team.id.to_s + '\/summary]'
          assert_select 'td:nth-child(3)', achievement.created_at.strftime("%b %e %y, %R %Z")
        end
      end
    end
  end
end
