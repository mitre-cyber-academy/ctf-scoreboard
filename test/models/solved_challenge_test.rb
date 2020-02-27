require 'test_helper'

class SolvedChallengeTest < ActiveSupport::TestCase
  # TODO: Add test for open_next_challenge to make sure it doesn't have any adverse affects
  # if a challenge is a PentestChallenge

  # TODO: Add test for GREATEST sql aggregation we do to make sure that works properly

  test 'team can solve challenge' do
    # Sublcasses of SolvedChallenge typically call super when Class#team_can_solve_challenge
    # returns false, which means that team has already solved the challenge.

    game = create(:active_game)
    team = create(:team)
    category = create(:category, game: game)
    challenge = create(:point_challenge)
    solved_challenge = create(:point_solved_challenge, team: team, challenge: challenge)

    solved_challenge = build(:point_solved_challenge, team: team, challenge: challenge)
    assert_not solved_challenge.valid?
    assert_includes solved_challenge.errors.full_messages, I18n.t('challenges.already_solved')
  end
end
