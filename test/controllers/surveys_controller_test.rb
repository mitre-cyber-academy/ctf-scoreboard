require 'test_helper'

class SurveysControllerTest < ActionController::TestCase

  def setup
    create(:active_game)
    @team1 = create(:team)
    @team2 = create(:team)
    @standard_challenge = create(:standard_challenge, flag_count: 3)
    @pentest_challenge = create(:pentest_challenge_with_flags)
  end

  test 'create new survey' do
    team_user = create(:user_with_team)
    standard_challenge = create(:standard_challenge)
    sign_in team_user
    submitted_flag = create(:submitted_flag, user: team_user, challenge: standard_challenge)
    post :create, params: { survey: { difficulty: 5, realism: 5, interest: 5, comment: "MyText", submitted_flag_id: submitted_flag.id } }
    assert_redirected_to game_path
    assert_match I18n.t('surveys.submitted'), flash[:notice]
  end
end
