FactoryBot.define do
  factory :score_adjustment, parent: :feed_item, class: 'ScoreAdjustment' do
    type { 'ScoreAdjustment' }
    point_value { 100 }
  end
end
