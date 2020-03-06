FactoryBot.define do
  factory :standard_solved_challenge, parent: :feed_item, class: 'StandardSolvedChallenge' do
    division { team.division }
    challenge { create(:standard_challenge) }
    flag { challenge.flags.sample }
  end
end
