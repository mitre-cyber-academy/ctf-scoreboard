# frozen_string_literal: true

source 'https://rubygems.org'

gem 'activerecord-precounter'
gem 'awesome_nested_fields'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bullet'
gem 'bootstrap', '~> 4.5.0'
gem 'bootstrap4-kaminari-views'
gem 'carrierwave-postgresql', '< 0.3.0' # Can be upgraded once https://github.com/diogob/carrierwave-postgresql/issues/33
gem 'chartkick'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise'
gem 'filterrific'
gem 'font-awesome-rails'
gem 'formtastic'
gem 'geocoder'
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
gem 'pg'
gem 'popper_js', '~> 1.14.5'
gem 'prawn'
gem 'rails', '~> 6.0.2'
gem 'rails_admin'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'rubyzip'
gem 'sentry-raven'

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
  gem 'sass-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'mini_racer', platforms: :ruby
  gem 'uglifier'
end

group :production do
  gem 'scout_apm'
end
