require 'test_helper'

class SolvedChallengeTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_game)
    @team = create(:team)
  end

  test 'solving challenge opens next challenge no category' do
    challenge1 = create(:standard_challenge, point_value: 100, category_count: 0)
    challenge2 = create(:closed_standard_challenge, point_value: 200, category_count: 0)
    challenge3 = create(:closed_standard_challenge, point_value: 300, category_count: 0)

    assert_equal true, challenge2.closed?
    create(:standard_solved_challenge, team: @team, challenge: challenge1)
    assert_equal true, challenge2.reload.open?
    assert_equal true, challenge3.reload.closed?
  end

  test 'solving challenge opens next challenge single category' do
    cat1 = create(:category)
    challenge1 = create(:standard_challenge, point_value: 100, category_count: 0, categories: [cat1])
    challenge2 = create(:closed_standard_challenge, point_value: 200, category_count: 0, categories: [cat1])
    challenge3 = create(:closed_standard_challenge, point_value: 300, category_count: 0, categories: [cat1])

    assert_equal true, challenge2.closed?
    create(:standard_solved_challenge, team: @team, challenge: challenge1)
    assert_equal true, challenge2.reload.open?
    assert_equal true, challenge3.reload.closed?
  end

  test 'solving challenge opens only next challenge multi category' do
    cat1 = create(:category)
    cat2 = create(:category)
    challenge1 = create(:standard_challenge, point_value: 100, category_count: 0, categories: [cat1, cat2])
    challenge2 = create(:closed_standard_challenge, point_value: 200, category_count: 0, categories: [cat1, cat2])
    challenge3 = create(:closed_standard_challenge, point_value: 300, category_count: 0, categories: [cat1, cat2])

    assert_equal true, challenge2.closed?
    create(:standard_solved_challenge, team: @team, challenge: challenge1)
    assert_equal true, challenge2.reload.open?
    assert_equal true, challenge3.reload.closed?
  end

  test 'solving challenge force close does not open next challenge single category' do
    cat1 = create(:category)
    challenge1 = create(:standard_challenge, point_value: 100, category_count: 0, categories: [cat1])
    challenge2 = create(:force_closed_standard_challenge, point_value: 200, category_count: 0, categories: [cat1])

    assert_equal true, challenge2.force_closed?
    create(:standard_solved_challenge, team: @team, challenge: challenge1)
    assert_equal true, challenge2.reload.force_closed?
  end

  test 'team can solve challenge' do
    # Subclass of SolvedChallenge typically call super when Class#team_can_solve_challenge
    # returns false, which means that team has already solved the challenge.

    category = create(:category)
    challenge = create(:standard_challenge)
    solved_challenge = create(:standard_solved_challenge, team: @team, challenge: challenge)

    solved_challenge = build(:standard_solved_challenge, team: @team, challenge: challenge)
    assert_not solved_challenge.valid?
    assert_includes solved_challenge.errors.full_messages, I18n.t('challenges.already_solved')
  end
end
