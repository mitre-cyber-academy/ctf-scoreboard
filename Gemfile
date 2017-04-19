# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.3.4'

gem 'awesome_nested_fields'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'devise'
gem 'formtastic'
gem 'haml-rails'
gem 'paper_trail'
gem 'paperclip'
gem 'rails', '~> 5.0.0'
gem 'rails_admin'
# The devise_security_extension gem is most likely the one causing all the depreciation warning on startup.
gem 'devise_security_extension', '~> 0.9.2' # Can update whenever they loosen their dependency on devise.
gem 'filterrific'
gem 'jquery-rails'
gem 'obscenity'
gem 'pg'
gem 'rails_email_validator'

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
