require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    create(:active_game)
    create(:user_with_team)
  end

  test 'creating a message by default doesn\'t send an email' do
    create(:message)

    assert ActionMailer::Base.deliveries.empty?
  end

  test 'creating a message that should send an email does send an email' do
    create(:message, email_message: true)

    assert_not ActionMailer::Base.deliveries.empty?
  end
end
