# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    transient do
      additional_member_count { 0 }
      compete_for_prizes { false }
    end
    team_name { Faker::Team.name + rand().to_s } # Avoid team name collisions
    affiliation { Faker::Educator.university }

    division { create(:point_division) }

    after(:build) do |team, evaluator|
      team.team_captain = create(:user, compete_for_prizes: evaluator.compete_for_prizes) unless team.team_captain
    end

    after(:create) do |team, evaluator|
      team.users << team.team_captain unless team.users.include?(team.team_captain)

      evaluator.additional_member_count.times do
        team.users << create(:user)
      end
    end

    factory :team_in_top_ten do
      after(:create) do |team|
        if team.division.is_a?(PointDivision)
          create(:point_solved_challenge, team: team)
        else
          create(:pentest_solved_challenge, team: team)
        end
      end
    end
  end
end
