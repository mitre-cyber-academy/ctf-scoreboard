# frozen_string_literal: true

FactoryBot.define do
  factory :share_challenge, parent: :base_share_challenge, class: 'ShareChallenge' do
    type { 'ShareChallenge' }

    after(:build) do |challenge, evaluator|
      evaluator.flag_count.times do
        create(:flag, challenge: challenge)
      end
    end

    factory :share_challenge_with_achievement do
      achievement_name { 'achievement triggered by challenge completion' }
    end
  end
end
