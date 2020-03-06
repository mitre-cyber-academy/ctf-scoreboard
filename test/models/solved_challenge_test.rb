require 'test_helper'

class SolvedChallengeTest < ActiveSupport::TestCase
  # TODO: Add test for open_next_challenge to make sure it doesn't have any adverse affects
  # if a challenge is a PentestChallenge

  # TODO: Add test for GREATEST sql aggregation we do to make sure that works properly

  def setup
    @game = create(:active_game)
  end

  test 'solving challenge opens next challenge no category' do
    team = create(:team)
    challenge1 = create(:point_challenge, point_value: 100, category_count: 0)
    challenge2 = create(:closed_point_challenge, point_value: 200, category_count: 0)
    challenge3 = create(:closed_point_challenge, point_value: 300, category_count: 0)

    assert_equal true, challenge2.closed?
    create(:point_solved_challenge, team: team, challenge: challenge1)
    assert_equal true, challenge2.reload.open?
    assert_equal true, challenge3.reload.closed?
  end

  test 'solving challenge opens next challenge single category' do
    team = create(:team)
    cat1 = create(:category)
    challenge1 = create(:point_challenge, point_value: 100, category_count: 0, categories: [cat1])
    challenge2 = create(:closed_point_challenge, point_value: 200, category_count: 0, categories: [cat1])
    challenge3 = create(:closed_point_challenge, point_value: 300, category_count: 0, categories: [cat1])

    assert_equal true, challenge2.closed?
    create(:point_solved_challenge, team: team, challenge: challenge1)
    assert_equal true, challenge2.reload.open?
    assert_equal true, challenge3.reload.closed?
  end

  test 'solving challenge opens only next challenge multi category' do
    team = create(:team)
    cat1 = create(:category)
    cat2 = create(:category)
    challenge1 = create(:point_challenge, point_value: 100, category_count: 0, categories: [cat1, cat2])
    challenge2 = create(:closed_point_challenge, point_value: 200, category_count: 0, categories: [cat1, cat2])
    challenge3 = create(:closed_point_challenge, point_value: 300, category_count: 0, categories: [cat1, cat2])

    assert_equal true, challenge2.closed?
    create(:point_solved_challenge, team: team, challenge: challenge1)
    assert_equal true, challenge2.reload.open?
    assert_equal true, challenge3.reload.closed?
  end

  test 'solving challenge force close does not open next challenge single category' do
    team = create(:team)
    cat1 = create(:category)
    challenge1 = create(:point_challenge, point_value: 100, category_count: 0, categories: [cat1])
    challenge2 = create(:force_closed_point_challenge, point_value: 200, category_count: 0, categories: [cat1])

    assert_equal true, challenge2.force_closed?
    create(:point_solved_challenge, team: team, challenge: challenge1)
    assert_equal true, challenge2.reload.force_closed?
  end

  test 'team can solve challenge' do
    # Subclass of SolvedChallenge typically call super when Class#team_can_solve_challenge
    # returns false, which means that team has already solved the challenge.

    team = create(:team)
    category = create(:category)
    challenge = create(:point_challenge)
    solved_challenge = create(:point_solved_challenge, team: team, challenge: challenge)

    solved_challenge = build(:point_solved_challenge, team: team, challenge: challenge)
    assert_not solved_challenge.valid?
    assert_includes solved_challenge.errors.full_messages, I18n.t('challenges.already_solved')
  end
end
