FactoryBot.define do
  factory :point_solved_challenge, parent: :feed_item, class: 'PointSolvedChallenge' do
    division { team.division }
    challenge { create(:point_challenge) }
    flag { challenge.flags.sample }
  end
end
