# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.3.5'

gem 'awesome_nested_fields'
gem 'aws-sdk-s3'
gem 'bluecloth'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'chartkick'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise'
gem 'filterrific'
gem 'formtastic'
gem 'geocoder'
gem 'groupdate'
gem 'haml-rails'
gem 'jquery-rails'
gem 'obscenity'
gem 'paper_trail'
gem 'passenger', require: 'phusion_passenger/rack_handler'
gem 'pg'
gem 'prawn'
gem 'rails', '~> 5.1.0'
gem 'rails_admin'
gem 'rails_email_validator'
gem 'sentry-raven'

gem 'letter_opener', group: :development

group :development, :test do
  gem 'pry-remote'
end

group :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'coveralls', require: false
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
  gem 'uglifier'
end

group :production do
  gem 'scout_apm'
end
