require 'test_helper'

class TeamDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:active_game)
  end

  test 'team creation header shows when visiting team creation page' do
    sign_in create(:user)
    get "/teams/new"

    assert_select 'h1', /Create a Team/
  end

  test 'ensure that there is a form on the team creation page' do
    sign_in create(:user)
    get "/teams/new"

    assert_select 'form[id=new_team]' do
      assert_select 'label:nth-child(1)', 'Team name'
      assert_select 'label:nth-child(1)', 'Affiliation'
      assert_select 'label:nth-child(1)', 'Division'
    end
  end

  test 'join team header shows when visiting team join page' do
    sign_in create(:user)
    get "/users/join_team"
    assert_response :success
    assert_select 'h1', /Join a Team/
  end

  test 'ensure the form is shown correctly on join team page' do
    sign_in create(:user)
    get "/users/join_team"

    assert_select 'form[id=filterrific_filter]' do
      assert_select 'div[class=form-group\ row]' do
        assert_select 'div:nth-child(1)', /Team Name/
        assert_select 'div:nth-child(2)', /Affiliation/
        assert_select 'div:nth-child(3)', /Location/
        assert_select 'div:nth-child(4)', /Division/
      end
    end
  end

  test 'team page displays correctly' do
    team = create(:team, team_name: 'Example Team', division: create(:division, name: 'Example Division'))
    chal = create(:standard_challenge, point_value: 100, category_count: 2)
    create(:standard_solved_challenge, challenge: chal, team: team)
    user = team.team_captain
    user.compete_for_prizes = false
    sign_in user

    get "/teams/#{team.id}"

    assert_select 'h1', /Example Team/
    assert_select 'h1', /ineligible/
    assert_select 'h1', /100/

    assert_select 'table[class=table\ table-condensed\ table-striped\ table-hover]' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', I18n.t('teams.users_table.team_leader_header')
          assert_select 'th:nth-child(2)', I18n.t('teams.users_table.email_header')
          assert_select 'th:nth-child(3)', I18n.t('teams.users_table.grade_header')
          assert_select 'th:nth-child(4)', I18n.t('teams.users_table.prize_eligibility_header')
          assert_select 'th:nth-child(5)', I18n.t('teams.users_table.remove_user_header')
          assert_select 'th:nth-child(6)', I18n.t('teams.users_table.change_captian_header')
        end
      end
      assert_select 'tbody' do
        assert_select 'td:nth-child(1)' do
          assert_select 'i'
        end
        assert_select 'td:nth-child(2)', team.team_captain.email
        assert_select 'td:nth-child(4)', 'No'
        assert_select 'td:nth-child(5)' do
          assert_select 'i'
        end
        assert_select 'td:nth-child(6)'
      end
    end

    assert_select 'body' do
      assert_select 'div[class=container]' do
        assert_select 'div:nth-child(1)' do
          assert_select 'div:nth-child(1)' do
            assert_select 'h4', I18n.t('teams.show.team_prize_eligibility_status')
          end
          assert_select 'div:nth-child(1)', /Your team is currently/
          assert_select 'div:nth-child(1)', /NOT/
          assert_select 'div:nth-child(1)', /competing for prizes/
        end
      end
      assert_select 'div:nth-child(2)' do
        assert_select 'h4', I18n.t('teams.show.team_division_status')
      end
      assert_select 'div:nth-child(2)', /Example Division/
    end
  end

  test 'solved challenges show on team summary page' do
    team = create(:team)
    chal = create(:standard_challenge, point_value: 100, category_count: 2)
    solve = create(:standard_solved_challenge, challenge: chal, team: team)
    user = team.team_captain
    sign_in user

    get "/teams/#{team.id}/summary"

    assert_select 'table[class=table\ table-bordered\ table-striped\ table-hover]' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th:nth-child(1)', I18n.t('teams.summary.solved_challenges_table.challenge_header')
          assert_select 'th:nth-child(2)', I18n.t('teams.summary.solved_challenges_table.points_header')
          assert_select 'th:nth-child(3)', I18n.t('teams.summary.solved_challenges_table.when_header')
        end
      end
      assert_select 'tbody' do
        assert_select 'tr' do
          assert_select 'td:nth-child(1)' do
            assert_select 'a[href=\/game\/challenges\/' + chal.id.to_s + ']'
          end
          assert_select 'td:nth-child(2)', '100'
          assert_select 'td:nth-child(3)', solve.created_at.strftime('%B %e at %l:%M %p %Z')
        end
      end
    end
  end
end
