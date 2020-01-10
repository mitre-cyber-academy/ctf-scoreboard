# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { ['Binary', 'Forensics', 'Web', 'Networking'].sample }

    game
  end
end
