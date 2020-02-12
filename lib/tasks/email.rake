# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :email do
  desc 'Configure email provider'
  task configure: :environment do
    def check_yes(response)
      return true if response.start_with?('Y', 'y', 'true')

      false
    end

    ui = HighLine.new
    ui.say('This task will create an initializer with the provided ActionMailer settings in
           config/initializers/action_mailer.rb.')
    ui.say('All configuration changes require a restart of all Rails threads.')
    ui.say("<%= color('Important Note: This program will write your SMTP password to disk!', BOLD) %>")
    address = ui.ask('SMTP server address: ')
    port = ui.ask('SMTP server port: ', Integer).to_s { |q| q.in = 0..65_535 }
    domain = ui.ask('Specify a HELO domain: ')
    default_url_options_host = ui.ask('Specify the host that mail will be sent from (i.e. app.heroku.com): ')
    authentication = ui.choose do |menu|
      menu.prompt = 'Select how Rails will authenticate to the SMTP server:'
      menu.choices(:plain, :login, :cram_md5)
      menu.default = :plain
    end

    tls = ui.ask('Enable the SMTP connection to use SMTP over TLS (Y/n)? ')
    enable_starttls_auto = ui.ask('Detect if STARTTLS is enabled on your SMTP server and use it? (Y/n): ')

    openssl_verify_mode = ui.choose do |menu|
      menu.prompt = 'Select how OpnSSL will validate the TLS certificate:'
      menu.choices('none', 'peer')
      menu.default = 'peer'
    end

    tls = check_yes(tls)
    enable_starttls_auto = check_yes(enable_starttls_auto)

    smtp_server_username = ui.ask('SMTP server username: ')
    smtp_server_password = ui.ask('SMTP server password: ') { |q| q.echo = false }

    config = <<~CONF
      ActionMailer::Base.default_url_options[:host] = '#{default_url_options_host}'
      ActionMailer::Base.smtp_settings = {
        address: '#{address}',
        port: '#{port}',
        domain: '#{domain}',
        authentication: :#{authentication},
        tls: #{tls},
        openssl_verify_mode: '#{openssl_verify_mode}',
        enable_starttls_auto: #{enable_starttls_auto},
        user_name: '#{smtp_server_username}',
        password: '#{smtp_server_password}'
      }
    CONF

    File.write(Rails.root.join('config/initializers/action_mailer.rb'), config)
  end

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
# rubocop:enable Metrics/BlockLength
