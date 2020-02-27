# frozen_string_literal: true

FactoryBot.define do
  factory :defense_flag, parent: :flag, class: 'DefenseFlag' do
    team { create(:team) }
    challenge { create(:pentest_challenge) }

    challenge_state { :inherit_parent_state }
  end
end
