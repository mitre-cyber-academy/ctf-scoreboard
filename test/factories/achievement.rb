FactoryBot.define do
  factory :achievement, parent: :feed_item, class: 'Achievement' do
    type { 'Achievement' }
    point_value { 100 }
  end
end
