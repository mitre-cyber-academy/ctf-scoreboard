require 'coveralls'
Coveralls.wear!('rails')

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  setup do
    ActionMailer::Base.deliveries = []
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActionView::TestCase
  include Devise::Test::ControllerHelpers
end
