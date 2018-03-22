require 'coveralls'
Coveralls.wear!

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  setup do
    ActionMailer::Base.deliveries = []
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def add_resume_transcript_to(user)
    user.resume = File.open(Rails.root.join('test/files/regular.pdf'))
    user.transcript = File.open(Rails.root.join('test/files/regular.pdf'))
    user.save!
    user
  end
end

class ActionView::TestCase
  include Devise::Test::ControllerHelpers
end
