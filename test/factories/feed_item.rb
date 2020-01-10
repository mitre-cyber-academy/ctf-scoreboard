# frozen_string_literal: true

FactoryBot.define do
  factory :feed_item do
    text { 'Did something good or bad' }
    team

    factory :achievement, class: 'Achievement' do
      type { 'Achievement' }
      point_value { 100 }
    end

    factory :score_adjustment, class: 'ScoreAdjustment' do
      type { 'ScoreAdjustment' }
      point_value { 100 }
    end

    factory :solved_challenge, class: 'SolvedChallenge' do
      type { 'SolvedChallenge' }
      division { team.division }
      challenge
      flag { challenge.flags.sample }
    end
  end
end
