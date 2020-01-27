FactoryBot.define do
  factory :point_challenge, parent: :challenge, class: 'PointChallenge' do
    type { 'PointChallenge' }
    category

    # flags_attributes { flag_count.times.map {FactoryBot.attributes_for(:challenge_flag)} }

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
