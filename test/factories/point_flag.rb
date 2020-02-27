# frozen_string_literal: true

FactoryBot.define do
  factory :point_flag, parent: :flag, class: 'PointFlag' do
    challenge { create(:point_challenge) }

    factory :point_flag_with_video do
      video_url { 'example_video_url' }
    end
  end
end
