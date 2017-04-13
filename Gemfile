source 'https://rubygems.org'

ruby '2.3.3'

gem 'rails', '~> 5.0.0'
gem 'devise'
gem "haml-rails"
gem "formtastic"
gem "awesome_nested_fields"
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'rails_admin'
gem "paperclip"
# The devise_security_extension gem is most likely the one causing all the depreciation warning on startup.
gem 'devise_security_extension', '~> 0.9.2' # Can update whenever they loosen their dependency on devise.
gem 'rails_email_validator'
gem 'jquery-rails'
gem 'filterrific'
gem 'pg'
gem 'obscenity'

gem 'letter_opener', :group => :development

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'coveralls', require: false
  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'bundler-audit', require: false
  gem 'rails-controller-testing'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier'
end

group :production do
  gem 'passenger'
end
