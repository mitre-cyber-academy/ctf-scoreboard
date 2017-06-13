# frozen_string_literal: true

namespace :email do
  desc 'Send reminder email to all users'
  task reminder_email: :environment do
    Game.instance.remind_all
  end

  desc 'Send completion email to all users on teams'
  task completion_email: :environment do
    Game.instance.send_rankings
  end

  desc 'Send resume request email to all users on the top ten teams for each division'
  task resume_email: :environment do
    Game.instance.request_resumes
  end

  desc 'Send email depending on date in relation to game start and end'
  task automated_email: :environment do
    game = Game.instance
    if game.start.middle_of_day.eql?(Time.now.utc.middle_of_day + 1.week)
      Rake::Task['email:reminder_email'].invoke
    elsif game.stop.middle_of_day.eql?(Time.now.utc.middle_of_day - 1.day)
      Rake::Task['email:completion_email'].invoke
      Rake::Task['email:resume_email'].invoke
    end
  end
end
