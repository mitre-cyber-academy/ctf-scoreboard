# frozen_string_literal: true

FactoryBot.define do
  factory :challenge do
    name { 'challenge' }
    description { 'challenge description' }
    point_value { 100 }
    state { :open }

    transient do
      flag_count { 1 }
    end

    # flags_attributes { flag_count.times.map {FactoryBot.attributes_for(:flag)} }
  end
end
