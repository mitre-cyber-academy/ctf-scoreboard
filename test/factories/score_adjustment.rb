FactoryBot.define do
  factory :point_score_adjustment, parent: :point_feed_item, class: 'ScoreAdjustment' do
    type { 'ScoreAdjustment' }
    point_value { 100 }
  end

  factory :pentest_score_adjustment, parent: :pentest_feed_item, class: 'ScoreAdjustment' do
    type { 'ScoreAdjustment' }
    point_value { 100 }
  end
end
