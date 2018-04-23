require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'instance is singleton' do
    game = Game.new(
      name: 'game',
      start: Time.now,
      stop: Time.now - 10.hours,
      description: 'game description'
    )
    assert_not game.valid?
    assert_equal true, game.errors.added?(:base, I18n.t('game.too_many'))
  end

  test 'order of start stop date' do
    game = Game.new(
      name: 'game',
      start: Time.now,
      stop: Time.now - 10.hours,
      description: 'game description'
    )
    assert_not game.valid?
    assert_equal true, game.errors.added?(:base, I18n.t('game.date_mismatch'))
  end

  test 'open' do
    assert_equal true, games(:mitre_ctf_game).open?
  end

  test 'send reminder emails' do
    game = games(:mitre_ctf_game)
    game.remind_all
    assert_equal User.all.size, ActionMailer::Base.deliveries.size
  end

  test 'send open source emails' do
    game = games(:mitre_ctf_game)
    game.open_source
    assert_equal User.all.size, ActionMailer::Base.deliveries.size
  end
end
