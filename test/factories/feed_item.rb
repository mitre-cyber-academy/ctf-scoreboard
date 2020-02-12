# frozen_string_literal: true

FactoryBot.define do
  factory :feed_item do
    text { 'Did something good or bad' }

    factory :point_feed_item do
      team { create(:point_team) }
    end

    factory :pentest_feed_item do
      team { create(:pentest_team) }
    end
  end
end
