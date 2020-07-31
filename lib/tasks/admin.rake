# frozen_string_literal: true

require 'highline'

namespace :db do
  desc 'Setup administrator in the database'
  task create_admin: :environment do
    puts 'This task will create a user account and make that user an administrator of the scoreboard.'
    ui = HighLine.new
    name = ui.ask('Your Name: ')
    email = ui.ask('Your Email: ')
    password = ui.ask('Enter password: ') { |q| q.echo = false }
    confirm  = ui.ask('Confirm password: ') { |q| q.echo = false }
    user = User.new(full_name: name, email: email, password: password, password_confirmation: confirm, admin: true)
    user.skip_confirmation!
    if user.save
      puts "User account '#{email}' created."
    else
      puts 'Problem creating user account:'
      puts
      puts user.errors.full_messages
    end
  end
end
