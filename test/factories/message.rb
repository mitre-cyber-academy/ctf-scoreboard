# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    title { 'test message' }
    text { 'this is an example message' }

    email_message { false }

    game
  end
end
