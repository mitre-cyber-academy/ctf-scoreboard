# frozen_string_literal: true

namespace :setup do
  desc 'Perform the initial set up and configuration of the gameboard and registration'
  task all: :environment do
    Rake::Task['db:create_admin'].invoke
    Rake::Task['email:configure'].invoke
    Rake::Task['recaptcha:configure'].invoke
  end
end
