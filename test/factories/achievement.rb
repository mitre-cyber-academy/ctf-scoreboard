FactoryBot.define do
  trait :base_achievement do
    type { 'Achievement' }
    point_value { 100 }
  end

  factory :achievement, parent: :feed_item, class: 'Achievement' do
    base_achievement
  end
end
