require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = create(:active_game)
  end

  test 'instance is singleton' do
    create(:active_game)

    game = Game.new(
      title: 'game',
      start: Time.now,
      stop: Time.now - 10.hours,
      description: 'game description'
    )
    assert_not game.valid?
    assert_equal true, game.errors.added?(:base, I18n.t('game.too_many'))
  end

  test 'order of start stop date' do
    game = build(:game, start: Time.now + 10.hours, stop: Time.now)
    assert_not game.valid?
    assert_equal true, game.errors.added?(:base, I18n.t('game.date_mismatch'))
  end

  test 'open' do
    assert_equal true, @game.open?
  end

  test 'send reminder emails' do
    game = create(:unstarted_game)
    create(:team)
    game.remind_all
    assert_equal User.all.size, ActionMailer::Base.deliveries.size
  end

  test 'send open source emails' do
    game = create(:ended_game)
    create(:team)
    game.open_source
    assert_equal User.all.size, ActionMailer::Base.deliveries.size
  end

  test 'before competition' do
    game = create(:ended_game)
    assert_not game.before_competition?
  end

  test 'after competition' do
    game = create(:ended_game)
    assert game.after_competition?
  end
  # TODO: Add test verifying the order is correct with only solved pentest challenges,
  # only solved point challenges, and a mixture.
  test 'all teams information' do
    team = create(:team)
    information = @game.all_teams_information
    assert_equal 1, information.length
    information = information.first
    assert_equal information[:team], team.team_name
    assert_equal information[:score], team.score
    assert_equal information[:pos], team.find_rank
  end

  test 'flags and associated teams' do
    team1 = create(:team)
    team2 = create(:team)
    create(:pentest_challenge_with_flags)
    create(:pentest_challenge_with_flags)
    @game.teams_associated_with_flags_and_pentest_challenges
  end

  test 'game can be deleted and cleans up appropriate relationships' do
    team = create(:team)
    create(:point_challenge)
    create(:pentest_challenge_with_flags)

    @game.destroy

    assert_equal 0, Game.count
    assert_equal 0, Team.count
    assert_equal 0, Challenge.count
    assert_equal 0, Division.count
  end
end
