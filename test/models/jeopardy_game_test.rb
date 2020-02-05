require 'test_helper'

class JeopardyGameTest < ActiveSupport::TestCase
  test 'instance is singleton' do
    create(:active_jeopardy_game)

    game = JeopardyGame.new(
      title: 'game',
      start: Time.now,
      stop: Time.now - 10.hours,
      description: 'game description'
    )
    assert_not game.valid?
    assert_equal true, game.errors.added?(:base, I18n.t('game.too_many'))
  end

  test 'order of start stop date' do
    game = build(:active_jeopardy_game, start: Time.now + 10.hours, stop: Time.now)
    assert_not game.valid?
    assert_equal true, game.errors.added?(:base, I18n.t('game.date_mismatch'))
  end

  test 'open' do
    assert_equal true, create(:active_jeopardy_game).open?
  end

  test 'send reminder emails' do
    game = create(:unstarted_jeopardy_game)
    create(:point_team)
    game.remind_all
    assert_equal User.all.size, ActionMailer::Base.deliveries.size
  end

  test 'send open source emails' do
    game = create(:ended_jeopardy_game)
    create(:point_team)
    game.open_source
    assert_equal User.all.size, ActionMailer::Base.deliveries.size
  end

  test 'before competition' do
    game = create(:ended_jeopardy_game)
    assert_not game.before_competition?
  end

  test 'after competition' do
    game = create(:ended_jeopardy_game)
    assert game.after_competition?
  end

  test 'all teams information' do
    game = create(:active_jeopardy_game)
    team = create(:point_team)
    information = game.all_teams_information
    assert_equal 1, information.length
    information = information.first
    assert_equal information[:team], team.team_name
    assert_equal information[:score], team.score
    assert_equal information[:pos], team.find_rank
  end
end
