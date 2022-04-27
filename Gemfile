# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.7.2'

gem 'activerecord-precounter'
gem 'activerecord-session_store'
gem 'awesome_nested_fields'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.5.0'
gem 'bootstrap4-kaminari-views'
gem 'carrierwave-postgresql', '< 0.3.0' # Can be upgraded once https://github.com/diogob/carrierwave-postgresql/issues/33
gem 'chartkick'
gem 'country_select', '~> 6.0'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise'
# Temporary until a filteriffic version with the native (non-jquery) version of filteriffic is released
# https://github.com/jhund/filterrific/pull/203
gem 'filterrific', github: 'jhund/filterrific', branch: '5.x'
gem 'font-awesome-rails'
gem 'formtastic'
gem 'groupdate'
gem 'haml-rails'
gem 'highcharts-rails'
gem 'highline'
gem 'jquery-rails'
gem 'kaminari'
gem 'kramdown'
gem 'obscenity'
gem 'paper_trail'
gem 'paper_trail-association_tracking'
gem 'passenger', require: 'phusion_passenger/rack_handler'
gem 'pg', '~> 1.2.3'
gem 'popper_js', '~> 1.14.5'
gem 'prawn'
gem 'rails', '~> 6.1.4'
gem 'rails_admin'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'rubyzip'
gem 'sentry-raven'
gem 'settingslogic', '~> 2.0.9'

group :development do
  gem 'letter_opener'
  gem 'listen'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-remote'
end

group :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'ffi-hunspell'
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
  gem 'rubocop-rails'
  gem 'simplecov', require: false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'sass-rails', '>= 5'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'mini_racer', platforms: :ruby
  gem 'uglifier'
end
gem 'sassc-rails'
