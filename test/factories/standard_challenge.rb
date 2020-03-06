FactoryBot.define do
  factory :standard_challenge, parent: :challenge, class: 'StandardChallenge' do
    type { 'StandardChallenge' }

    after(:build) do |challenge, evaluator|
      evaluator.flag_count.times do
        create(:standard_flag, challenge: challenge)
      end
    end

    factory :closed_standard_challenge do
      state { :closed }
    end

    factory :force_closed_standard_challenge do
      state { :force_closed }
    end

    factory :standard_challenge_with_achievement do
      achievement_name { 'achievement triggered by challenge completion' }
    end
  end
end
