require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase
  include ChallengesHelper

  def setup
    create(:active_game)
    @team1 = create(:team)
    @team2 = create(:team)
    @standard_challenge = create(:standard_challenge, flag_count: 3)
    @pentest_challenge = create(:pentest_challenge_with_flags)
  end

  test 'should get show for standard challenge' do
    sign_in create(:user_with_team)
    get :show, params: {
      id: @standard_challenge
    }
    assert_response :success
  end

  test 'show pentest challenge' do
    sign_in @team1.team_captain
    get :show, params: { id: @pentest_challenge, team_id: @team1 }
    assert_response :success
  end

  test 'show pentest challenge fails with no team ID' do
    sign_in @team1.team_captain
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, params: { id: @pentest_challenge }
    end
    assert_response :success
  end

  test "submit any of the correct flags when on a team" do
    @user = create(:user_with_team)
    sign_in @user
    assert_difference 'SubmittedFlag.count', +1 do
      put :update, params: {
        id: @standard_challenge,
        challenge: {
          submitted_flag: @standard_challenge.flags.sample.flag
        }
      }
    end
    assert :success
    assert_equal flash[:notice], I18n.t('flag.accepted')
  end

  test 'submit incorrect flag when on team' do
    sign_in create(:user_with_team)
    assert_difference 'SubmittedFlag.count', +1 do
      put :update, params: {
        id: create(:standard_challenge),
        challenge: {
          submitted_flag: "wrong"
        }
      }
    end
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no team' do
    sign_in create(:user)
    @standard_challenge = create(:standard_challenge)
    put :update, params: {
      id: @standard_challenge,
      challenge: {
        submitted_flag: @standard_challenge.flags.sample.flag
      }
    }
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no flag' do
    assert_no_difference 'SubmittedFlag.count' do
      sign_in create(:user_with_team)
      put :update, params: {
        id: create(:standard_challenge)
      }
    end
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no user' do
    put :update, params: {
      id: @standard_challenge,
      challenge: {
        submitted_flag: @standard_challenge.flags.sample.flag
      }
    }
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'submit flag with bad captcha' do
    Recaptcha.configuration.skip_verify_env.delete('test')
    Recaptcha.configure do |config|
      config.site_key = 'test_key'
      config.secret_key = 'test_key'
    end
    user = create(:user_with_team)
    sign_in user
    put :update, params: {
      id: @standard_challenge , challenge: {
        submitted_flag: @standard_challenge.flags.sample.flag
      }
    }
    assert_response :success
    assert_equal flash['alert'], I18n.t('devise.registrations.recaptcha_failed')
    Recaptcha.configuration.skip_verify_env << 'test'
  end

  test 'successfully submit flag to pentest challenge' do
    sign_in @team1.team_captain
    flag_text = @pentest_challenge.defense_flags.find_by(team_id: @team2.id).flag
    put :update, params: { id: @pentest_challenge, team_id: @team2, challenge: { submitted_flag: flag_text } }
    assert_response :success
    assert_equal I18n.t('flag.accepted'), flash[:notice]
  end

  test 'flag accepted shows on page reload for pentest challenge' do
    create(:pentest_solved_challenge, team: @team1, challenge: @pentest_challenge, flag: @team2.defense_flags.first)
    sign_in @team1.team_captain
    get :show, params: { id: @pentest_challenge, team_id: @team2 }
    assert_response :success
    assert_equal I18n.t('flag.accepted'), flash[:notice]
  end

  test 'solved challenge survey shows for pentest challenge when submitted flag is accepted' do
    create(:pentest_solved_challenge, team: @team1, challenge: @pentest_challenge, flag: @team2.defense_flags.first)
    sign_in @team1.team_captain
    get :show, params: { id: @pentest_challenge, team_id: @team2 }
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

  test 'flag accepted shows on page reload for standard challenge' do
    create(:standard_solved_challenge, challenge: @standard_challenge, team: @team1)
    sign_in @team1.team_captain
    get :show, params: { id: @standard_challenge }
    assert_response :success
    assert_equal I18n.t('flag.accepted'), flash[:notice]
  end

  test 'solved challenge survey shows for standard challenge when submitted flag is accepted' do
    create(:standard_solved_challenge, challenge: @standard_challenge, team: @team1)
    sign_in @team1.team_captain
    get :show, params: { id: @standard_challenge }
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

  test 'flag accepted shows on page reload for share challenge' do
    share_chal = create(:share_challenge)
    create(:standard_solved_challenge, challenge: share_chal, team: @team1)
    sign_in @team1.team_captain
    get :show, params: { id: share_chal }
    assert_response :success
    assert_equal I18n.t('flag.accepted'), flash[:notice]
  end

  test 'solved challenge survey shows for share challenge when submitted flag is accepted' do
    share_chal = create(:share_challenge)
    create(:standard_solved_challenge, challenge: share_chal, team: @team1)
    sign_in @team1.team_captain
    get :show, params: { id: share_chal }
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
