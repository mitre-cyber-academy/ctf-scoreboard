# frozen_string_literal: true

FactoryBot.define do
  factory :point_division, parent: :division, class: 'PointDivision' do
  end

  factory :point_hs_division, parent: :hs_division, class: 'PointDivision' do
  end

  factory :point_college_division, parent: :college_division, class: 'PointDivision' do
  end
end
