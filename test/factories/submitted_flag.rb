# frozen_string_literal: true

FactoryBot.define do
  factory :submitted_flag do
    text { 'user submitted flag guess' }
    user
    challenge
  end
end
