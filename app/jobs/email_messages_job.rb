# frozen_string_literal: true

# Sends the specified message to every user in the database.
class EmailMessagesJob < ApplicationJob
  queue_as :default

  def perform(message)
    User.all.find_each do |usr|
      UserMailer.message_notification(usr, message).deliver_later
    end
  end
end
