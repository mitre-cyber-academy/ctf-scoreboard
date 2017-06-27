# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.3.4'

gem 'awesome_nested_fields'
gem 'bluecloth'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'chartkick'
gem 'devise'
gem 'devise_security_extension', '~> 0.9.2' # Update when this loosens its dependency on devise. Also causes load errors
gem 'filterrific'
gem 'formtastic'
gem 'geocoder'
gem 'groupdate'
gem 'haml-rails'
gem 'jquery-rails'
gem 'obscenity'
gem 'paper_trail'
gem 'paperclip'
gem 'pg'
gem 'prawn'
gem 'rails', '~> 5.0.0'
gem 'rails_admin'
gem 'rails_email_validator'
gem 'sentry-raven'

gem 'letter_opener', group: :development

group :development, :test do
  gem 'pry'
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
  gem 'passenger'
end
