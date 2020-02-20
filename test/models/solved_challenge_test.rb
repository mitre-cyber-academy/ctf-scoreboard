require 'test_helper'

class SolvedChallengeTest < ActiveSupport::TestCase
  test 'team can solve challenge' do
    # Sublcasses of SolvedChallenge typically call super when Class#team_can_solve_challenge
    # returns false, which means that team has already solved the challenge.

    game = create(:active_point_game)
    team = create(:point_team)
    category = create(:category, game: game)
    challenge = create(:point_challenge)
    solved_challenge = create(:point_solved_challenge, team: team, challenge: challenge)

    solved_challenge = build(:point_solved_challenge, team: team, challenge: challenge)
    assert_not solved_challenge.valid?
    assert_includes solved_challenge.errors.full_messages, I18n.t('challenges.already_solved')
  end
end
