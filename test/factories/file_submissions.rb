# frozen_string_literal: true

FactoryBot.define do
  factory :file_submission do
    challenge_id { "" }
    user_id { "" }
    submitted_bundle { "" }
    description { "MyText" }
    demoed { false }
  end
end
