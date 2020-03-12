# frozen_string_literal: true

FactoryBot.define do
  factory :challenge do
    name { Faker::Hacker.unique.verb }
    description { Faker::Hacker.say_something_smart }
    point_value { 100 }
    game
    state { :open }

    transient do
      flag_count { 1 }
      category_count { 1 }
    end

    after(:build) do |challenge, evaluator|
      evaluator.category_count.times do
        challenge.categories << create(:category)
      end
    end
  end
end
