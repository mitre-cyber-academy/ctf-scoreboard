FactoryBot.define do
  factory :point_solved_challenge, parent: :solved_challenge, class: 'PointSolvedChallenge' do
    challenge { create(:point_challenge) }
  end
end
