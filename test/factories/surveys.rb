# frozen_string_literal: true

FactoryBot.define do
  factory :survey do
    difficulty { Faker::Number.between(from:1, to:5) }
    realism { Faker::Number.between(from:1, to:5) }
    interest { Faker::Number.between(from:1, to:5) }
    comment { "MyText" }
    submitted_flag_id { 1 }
  end
end
