# frozen_string_literal: true

namespace :reload do
  desc 'Reload user counter cache'
  task user_count: :environment do
    Game.instance.reload_user_count
  end
end
