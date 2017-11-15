require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'creating a message by default doesn\'t send an email' do
    Message.create!(
      game: games(:mitre_ctf_game),
      text: 'Message',
      title: 'Neat message'
    )

    assert ActionMailer::Base.deliveries.empty?
  end

  test 'creating a message that should send an email does send an email' do
    Message.create!(
      game: games(:mitre_ctf_game),
      text: 'Message',
      title: 'Neat message 2',
      email_message: true
    )

    assert_not ActionMailer::Base.deliveries.empty?
  end
end
