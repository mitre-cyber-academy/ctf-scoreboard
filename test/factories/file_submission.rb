# frozen_string_literal: true

FactoryBot.define do
  factory :file_submission do
    challenge { create(:file_submission_challenge) }
    user
    submitted_bundle { File.open(Rails.root.join('test/files/test_submission.zip')) }
    description { "MyText" }
    demoed { false }
  end
end
