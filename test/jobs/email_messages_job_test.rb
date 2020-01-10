require 'test_helper'

class EmailMessagesJobTest < ActiveJob::TestCase
  test "job properly enqueues emails for all users" do
    create(:active_game)
    create_list(:user, 10)
    perform_enqueued_jobs do
      message = create(:message, email_message: true)
    end
    assert_equal User.count, ActionMailer::Base.deliveries.count
  end
end
