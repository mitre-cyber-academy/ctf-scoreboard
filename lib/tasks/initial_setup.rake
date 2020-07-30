# frozen_string_literal: true

require 'rake'

namespace :db do
    desc 'Run initial setup of the scoreboard in one rake'
    task initial_setup: :environment do
        Rake::Task['db:create'].invoke
        Rake::Task['db:schema:load'].invoke
        Rake::Task['db:create_admin'].invoke
    end
end
