# frozen_string_literal: true

require 'highline'

namespace :db do
  desc 'Setup administrator in the database'
  task create_admin: :environment do
    puts 'This task will create a user account and make that user an administrator of the scoreboard.'
    if ENV['NAME'].nil? || ENV['EMAIL'].nil? || ENV['PASS'].nil?
      ui = HighLine.new
      name = ui.ask('Your Name: ')
      email = ui.ask('Your Email: ')
      password = ui.ask('Enter password: ') { |q| q.echo = false }
      confirm  = ui.ask('Confirm password: ') { |q| q.echo = false }
    else
      puts "Login credentials for unattended mode are: #{ENV['EMAIL']}:#{ENV['PASS']}"
      name = ENV['NAME']
      email = ENV['EMAIL']
      password = ENV['PASS']
      confirm = ENV['PASS']
    end
    user = User.new(full_name: name, email: email, password: password, password_confirmation: confirm, admin: true)
    user.skip_confirmation!
    if user.save
      puts "User account '#{email}' created."
    else
      puts
      puts 'Problem creating user account:'
      puts user.errors.full_messages
    end
  end
end
