require 'test_helper'

class SubmittedFlagsSurveyDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    create(:active_game)
    @team1 = create(:team)
    @team2 = create(:team)
    @standard_challenge = create(:standard_challenge, flag_count: 3)
    @pentest_challenge = create(:pentest_challenge_with_flags)
  end

  test 'solved challenge survey shows for pentest challenge when submitted flag is accepted' do
    create(:pentest_solved_challenge, team: @team1, challenge: @pentest_challenge, flag: @team2.defense_flags.first)
    sign_in @team1.team_captain
    get game_team_challenge_path(@team2, @pentest_challenge)
    assert_response :success
    if @flag_found
      assert_select 'form.well.form-inline' do
        assert_select 'h3', I18n.t('surveys.new.header')
        assert_select 'div.field', {:count => 3} do
          assert_select 'label'
          assert_select 'span.star-cb-group'
        end
        assert_select 'div.field' do
          assert_select 'label'
          assert_select 'textarea#survey_comment'
        end
        assert_select 'div.field' do
          assert_select 'input#survey_submitted_flag_id'
        end
        assert_select 'div.field' do
          assert_select 'input.btn.btn-primary[type=submit]'
        end
      end
    end
  end

  test 'solved challenge survey shows for standard challenge when submitted flag is accepted' do
    create(:standard_solved_challenge, challenge: @standard_challenge, team: @team1)
    sign_in @team1.team_captain
    get game_challenge_path(@standard_challenge)
    assert_response :success
    if @flag_found
      assert_select 'form.well.form-inline' do
        assert_select 'h3', I18n.t('surveys.new.header')
        assert_select 'div.field', {:count => 3} do
          assert_select 'label'
          assert_select 'span.star-cb-group'
        end
        assert_select 'div.field' do
          assert_select 'label'
          assert_select 'textarea#survey_comment'
        end
        assert_select 'div.field' do
          assert_select 'input#survey_submitted_flag_id'
        end
        assert_select 'div.field' do
          assert_select 'input.btn.btn-primary[type=submit]'
        end
      end
    end
  end

  test 'solved challenge survey shows for share challenge when submitted flag is accepted' do
    share_chal = create(:share_challenge)
    create(:standard_solved_challenge, challenge: share_chal, team: @team1)
    sign_in @team1.team_captain
    get game_challenge_path(share_chal)
    assert_response :success
    if @flag_found
      assert_select 'form.well.form-inline' do
        assert_select 'h3', I18n.t('surveys.new.header')
        assert_select 'div.field', {:count => 3} do
          assert_select 'label'
          assert_select 'span.star-cb-group'
        end
        assert_select 'div.field' do
          assert_select 'label'
          assert_select 'textarea#survey_comment'
        end
        assert_select 'div.field' do
          assert_select 'input#survey_submitted_flag_id'
        end
        assert_select 'div.field' do
          assert_select 'input.btn.btn-primary[type=submit]'
        end
      end
    end
  end
end
