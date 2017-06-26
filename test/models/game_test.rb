require 'test_helper'

class GameTest < ActiveSupport::TestCase

  def setup
    Game.instance.reload_user_count
  end

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
    before = ActionMailer::Base.deliveries.size
    game.remind_all
    assert_equal before + User.all.size, ActionMailer::Base.deliveries.size
  end

  test 'send ranking emails' do
    game = games(:mitre_ctf_game)
    before = ActionMailer::Base.deliveries.size
    game.generate_completion_certs
    user_count = 0
    Team.all.each do |team|
      team.users.each do |*|
        user_count = user_count + 1
      end
    end
    assert_equal before + user_count, ActionMailer::Base.deliveries.size
  end

  test 'generate all certs' do
    game = games(:mitre_ctf_game)
    game.generate_completion_certs false
    Division.all.find_each do |division|
      division.ordered_teams.each do |team|
        team.users.each do |user|
          user.reload
          assert_equal true, (File.exist? (Rails.root.to_s +
              "/tmp/#{user.transform division.name}-certificates/#{(user.transform team.team_name).delete("\/")}/#{user.transform}.pdf"))
        end
      end
    end
  end
end
