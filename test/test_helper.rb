require 'simplecov'

# Generate Pretty Report for local viewing or CI
if ENV['CI'] || ENV['LOCAL_COVERAGE']
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.minimum_coverage 100
end

SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end

  parallelize_teardown do |worker|
    SimpleCov.result
  end

  setup do
    ActionMailer::Base.deliveries = []
  end

  teardown do
    Rails.cache.clear
    Faker::Hacker.unique.clear
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include ActionView::Helpers::TextHelper
end

class ActionView::TestCase
  include Devise::Test::ControllerHelpers
end

# Construct the minimum parameters for user creation via controller action.
def build_user_params(user_obj)
  params = {
    'full_name': user_obj.full_name,
    'email': user_obj.email,
    'affiliation': user_obj.affiliation,
    'year_in_school': user_obj.year_in_school,
    'state': user_obj.state,
    'password': user_obj.password,
    'password_confirmation': user_obj.password,
  }
end

def remove_html_artifacts(email_body)
  strip_tags(email_body).gsub('=0D', '').gsub('E2=80=A6', '').gsub('=', '').gsub("\r", '').gsub("\n", '')
end
