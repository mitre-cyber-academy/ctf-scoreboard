FactoryBot.define do
  trait :base_achievement do
    type { 'Achievement' }
    point_value { 100 }
  end

  factory :point_achievement, parent: :point_feed_item, class: 'Achievement' do
    base_achievement
  end

  factory :pentest_achievement, parent: :pentest_feed_item, class: 'Achievement' do
    base_achievement
  end
end
