# frozen_string_literal: true

FactoryBot.define do
  factory :standard_flag, parent: :flag, class: 'StandardFlag' do
    challenge { create(:standard_challenge) }

    factory :standard_flag_with_video do
      video_url { 'example_video_url' }
    end
  end
end
