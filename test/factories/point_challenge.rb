FactoryBot.define do
  factory :point_challenge, parent: :challenge, class: 'PointChallenge' do
    type { 'PointChallenge' }
    category

    after(:build) do |challenge, evaluator|
      evaluator.flag_count.times do
        create(:challenge_flag, challenge: challenge)
      end
    end

    factory :point_challenge_with_achievement do
      achievement_name { 'achievement triggered by challenge completion' }
    end
  end
end
