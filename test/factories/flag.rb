# frozen_string_literal: true

FactoryBot.define do
  factory :flag do
    flag { Faker::Hacker.noun }

    challenge

    factory :flag_with_video do
      video_url { 'example_video_url' }
    end
  end
end
