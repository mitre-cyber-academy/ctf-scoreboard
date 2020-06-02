# frozen_string_literal: true

FactoryBot.define do
  factory :share_challenge, parent: :standard_challenge, class: 'ShareChallenge' do
    type { 'ShareChallenge' }

    factory :share_challenge_with_achievement do
      achievement_name { 'achievement triggered by challenge completion' }
    end
  end
end
