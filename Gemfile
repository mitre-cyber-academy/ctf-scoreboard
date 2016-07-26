source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 4.2.3'
gem 'devise'
gem "haml-rails"
gem "formtastic"
gem "awesome_nested_fields"
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'rails_admin'
gem "paperclip" , '~> 4.3.5'
gem 'devise_security_extension'
gem 'rails_email_validator'
gem 'jquery-rails'
gem 'filterrific'
gem 'pg'
gem 'obscenity'


group :test do
  gem 'coveralls', require: false
  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'bundler-audit', require: false
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