# frozen_string_literal: true

FactoryBot.define do
  factory :challenge_flag, parent: :flag, class: 'ChallengeFlag' do
    challenge { create(:point_challenge) }

    factory :challenge_flag_with_video do
      video_url { 'example_video_url' }
    end
  end
end
