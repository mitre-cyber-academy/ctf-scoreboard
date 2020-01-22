# frozen_string_literal: true

require 'highline'

namespace :recaptcha do
  desc 'Configure reCAPTCHA integration'
  task configure: :environment do
    ui = HighLine.new
    ui.say('This task will create an initializer with the provided reCAPTCHA settings in
           config/initializers/recaptcha.rb')
    ui.say('All configuration changes require a restart of all Rails threads.')
    ui.say("<%= color('Important Note: This program will write your reCAPTCHA secret keys to disk!', BOLD) %>")

    site_key = ui.ask('Site key: ')
    secret_key = ui.ask('Secret key: ')

    config = <<~CONF
      Recaptcha.configure do |config|
        config.site_key = '#{site_key}'
        config.secret_key = '#{secret_key}'
        config.skip_verify_env << Rails.env if ENV['RECAPTCHA_DISABLE']
      end
    CONF

    File.write(Rails.root.join('config/initializers/recaptcha.rb'), config)
  end
end
