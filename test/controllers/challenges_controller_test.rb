require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase
  include ChallengesHelper

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'should get show' do
    sign_in users(:user_one)
    get :show, params: {
      id: challenges(:challenge_one_cat_one)
    }
    assert_response :success
  end

  test 'submit correct flag' do
    sign_in users(:user_one)
    put :update, params: {
      id: challenges(:challenge_one_cat_one),
      challenge: {
        submitted_flag: flags(:flag_one).flag
      }
    }
    assert :success
    assert_equal flash[:notice], I18n.t('flag.accepted')
  end

  test 'submit incorrect flag' do
    sign_in users(:user_one)
    put :update, params: {
      id: challenges(:challenge_one_cat_one),
      challenge: {
        submitted_flag: "wrong"
      }
    }
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'send resume emails' do
    sign_in users(:user_on_team_with_special_chars)
    put :update, params: {
        id: challenges(:challenge_one_cat_one),
        challenge: {
            submitted_flag: flags(:flag_one).flag
        }
    }
    game = games(:mitre_ctf_game)
    before = ActionMailer::Base.deliveries.size

    game.request_resumes
    user_count = 0
    Team.find_each{|team| Team.reset_counters team.id, :users}
    Team.all.each do |team|
      next unless team.in_top_ten? && !team.division.acceptable_years_in_school.include?(0)
      team.users.each do |*|
        user_count = user_count + 1
      end
    end
    assert_equal before + user_count, ActionMailer::Base.deliveries.size
  end

  # Private methods
  test 'should get find_challenge' do
  end

  test 'should find and log flag' do
  end
end
