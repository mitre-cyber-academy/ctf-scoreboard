require 'test_helper'

class EmailMessagesJobTest < ActiveJob::TestCase
  test "job properly enqueues emails for all users" do
    message = messages(:message_one)
    EmailMessagesJob.perform_now(message)
    assert_enqueued_jobs User.count
  end
end
