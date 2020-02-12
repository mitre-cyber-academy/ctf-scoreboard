# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    transient do
      additional_member_count { 0 }
      compete_for_prizes { false }
    end
    team_name { Faker::Team.name + rand().to_s } # Avoid team name collisions
    affiliation { Faker::Educator.university }

    after(:build) do |team, evaluator|
      team.team_captain = create(:user, compete_for_prizes: evaluator.compete_for_prizes) unless team.team_captain
    end

    after(:create) do |team, evaluator|
      evaluator.additional_member_count.times do
        team.users << create(:user)
      end
    end

    factory :point_team do
      division { create(:point_division) }

      factory :point_team_in_top_ten do
        after(:create) do |team|
          create(:point_solved_challenge, team: team)
        end
      end
    end

    factory :pentest_team do
      division { create(:pentest_division) }

      factory :pentest_team_with_flags do
        after(:create) do |team|
          PentestChallenge.all.each do |challenge|
            create(:pentest_flag, team: team, challenge: challenge)
          end
        end
      end

      factory :pentest_team_in_top_ten do
        after(:create) do |team|
          create(:pentest_solved_challenge, team: team)
        end
      end
    end
  end
end
