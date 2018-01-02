# frozen_string_literal: true

class Message < ApplicationRecord
  after_create :send_email, if: :email_message?

  belongs_to :game, required: true

  validates :text, :title, presence: true

  private

  def send_email
    User.all.find_each do |usr|
      UserMailer.message_notification(usr, self).deliver_later
    end
  end
end
