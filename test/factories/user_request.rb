# frozen_string_literal: true

FactoryBot.define do
  factory :user_request do
    team
    user
  end
end
