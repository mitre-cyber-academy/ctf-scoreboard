# frozen_string_literal: true

FactoryBot.define do
  factory :feed_item do
    text { 'Did something good or bad' }
    team { create(:team) }
  end
end
