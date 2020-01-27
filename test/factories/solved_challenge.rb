FactoryBot.define do
  factory :solved_challenge, parent: :feed_item, class: 'SolvedChallenge' do
    division { team.division }
    challenge
    flag { challenge.flags.sample }
  end
end
