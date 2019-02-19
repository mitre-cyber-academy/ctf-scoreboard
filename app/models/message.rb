# frozen_string_literal: true

class Message < ApplicationRecord
  after_create :send_email, if: :email_message?

  belongs_to :game, optional: false

  validates :text, :title, presence: true

  private

  def send_email
    EmailMessagesJob.perform_later(self)
  end
end
