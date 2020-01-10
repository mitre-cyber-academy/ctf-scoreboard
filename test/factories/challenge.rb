# frozen_string_literal: true

FactoryBot.define do
  factory :challenge do
    name { 'challenge' }
    description { 'challenge description' }
    point_value { 100 }
    state { :open }

    category

    transient do
      flag_count { 1 }
    end

    flags_attributes { flag_count.times.map {FactoryBot.attributes_for(:flag)} }

    after(:build) do |challenge, evaluator|
      evaluator.flag_count.times do
        create(:flag, challenge: challenge)
      end
    end

    factory :challenge_with_achievement do
      achievement_name { 'achievement triggered by challenge completion' }
    end
  end
end
