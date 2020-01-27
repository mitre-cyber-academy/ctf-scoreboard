# frozen_string_literal: true

FactoryBot.define do
  factory :flag do
    flag { Faker::Hacker.noun }

    challenge
  end
end
