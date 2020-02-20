require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase
  include ChallengesHelper

  def setup
    create(:active_point_game)
    @challenge = create(:point_challenge, flag_count: 3)
  end

  test 'should get show' do
    sign_in create(:user_with_team)
    get :show, params: {
      id: @challenge
    }
    assert_response :success
  end

  test 'show challenge pentest game' do
    Game.first.destroy
    game = create(:active_pentest_game)
    team = create(:pentest_team)
    challenge = create(:pentest_challenge_with_flags, pentest_game: game)
    sign_in team.team_captain
    get :show, params: { id: challenge, team_id: team }
    assert_response :success
  end

  test "submit any of the correct flags when on a team" do
    @user = create(:user_with_team)
    sign_in @user
    assert_difference 'SubmittedFlag.count', +1 do
      put :update, params: {
        id: @challenge,
        challenge: {
          submitted_flag: @challenge.flags.sample.flag
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
        id: create(:point_challenge),
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
    @challenge = create(:point_challenge)
    put :update, params: {
      id: @challenge,
      challenge: {
        submitted_flag: @challenge.flags.sample.flag
      }
    }
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no flag' do
    assert_no_difference 'SubmittedFlag.count' do
      sign_in create(:user_with_team)
      put :update, params: {
        id: create(:point_challenge)
      }
    end
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no user' do
    put :update, params: {
      id: @challenge,
      challenge: {
        submitted_flag: @challenge.flags.sample.flag
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
      id: @challenge , challenge: {
        submitted_flag: @challenge.flags.sample.flag
      }
    }
    assert_response :success
    assert_equal flash['alert'], I18n.t('devise.registrations.recaptcha_failed')
    Recaptcha.configuration.skip_verify_env << 'test'
  end

  test 'update pentest game' do
    Game.first.destroy
    game = create(:active_pentest_game)
    team1 = create(:pentest_team)
    team2 = create(:pentest_team)
    # Creates a challenge for each team
    challenge = create(:pentest_challenge_with_flags, pentest_game: game)
    sign_in team1.team_captain
    flag_text = challenge.flags.find_by(team_id: team2.id).flag
    put :update, params: { id: challenge, team_id: team2, challenge: { submitted_flag: flag_text } }
    assert_response :success
    assert_equal I18n.t('flag.accepted'), flash[:notice]
  end

  test 'find design phase challenge' do
    Game.first.destroy

    game = create(:active_pentest_game)
    team1 = create(:pentest_team)
    challenge = create(:design_phase_pentest_challenge_with_flag, pentest_game: game)
    sign_in team1.team_captain
    get :show, params: { id: challenge }
    assert_response :success
  end
end
