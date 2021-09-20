# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    full_name { "First and Last Name #{rand()}" }
    email { Faker::Internet.email }
    affiliation { Faker::Educator.university }
    year_in_school { Faker::Number.between(from: 9, to: 16) }
    state { Faker::Address.state_abbr }
    country { 'US' }
    password { Faker::Internet.password(min_length: 12) }

    compete_for_prizes { false }

    confirmed_at { Time.zone.now }

    factory :user_with_team do
      after(:create) do |user|
        user.update(team: create(:team, team_captain: user))
      end
    end

    factory :user_with_resume do
      resume { File.open(Rails.root.join('test/files/regular.pdf')) }
      transcript { File.open(Rails.root.join('test/files/regular.pdf')) }
    end

    factory :admin do
      admin { true }
    end
  end
end
