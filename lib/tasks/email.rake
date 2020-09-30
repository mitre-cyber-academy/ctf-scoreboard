# frozen_string_literal: true

namespace :email do
  desc 'Send reminder email to all users'
  task reminder_email: :environment do
    Game.instance.remind_all
  end

  desc 'Send completion email to all users on teams'
  task completion_email: :environment do
    Division.all.each do |div|
      div.ordered_teams.each_with_index do |team, index|
        next if team.score.zero?

        team.users.each do |user|
          UserMailer.ranking(user, index + 1).deliver_later
        end
      end
    end
  end

  desc 'Send challenge open source notification email to all users'
  task open_source_email: :environment do
    Game.instance.open_source
  end

  desc 'Send email depending on date in relation to game start and end'
  task automated_email: :environment do
    game = Game.instance
    if game.start.middle_of_day.eql?(Time.now.utc.middle_of_day + 1.week) ||
       game.start.middle_of_day.eql?(Time.now.utc.middle_of_day)
      Rake::Task['email:reminder_email'].invoke
    elsif game.stop.middle_of_day.eql?(Time.now.utc.middle_of_day - 1.day)
      Rake::Task['email:completion_email'].invoke
    end
  end
end
