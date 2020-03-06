FactoryBot.define do
  factory :point_challenge, parent: :challenge, class: 'PointChallenge' do
    type { 'PointChallenge' }

    after(:build) do |challenge, evaluator|
      evaluator.flag_count.times do
        create(:point_flag, challenge: challenge)
      end
    end

    factory :closed_point_challenge do
      state { :closed }
    end

    factory :force_closed_point_challenge do
      state { :force_closed }
    end

    factory :point_challenge_with_achievement do
      achievement_name { 'achievement triggered by challenge completion' }
    end
  end
end
