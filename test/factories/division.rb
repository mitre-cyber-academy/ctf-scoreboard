# frozen_string_literal: true

FactoryBot.define do
  factory :division do
    name { 'Professional' }
    min_year_in_school { 0 }
    max_year_in_school { 16 }

    game

    factory :hs_division do
      name { 'High School' }
      min_year_in_school { 9 }
      max_year_in_school { 12 }
    end

    factory :college_division do
      name { 'College' }
      min_year_in_school { 13 }
      max_year_in_school { 16 }
    end
  end
end
