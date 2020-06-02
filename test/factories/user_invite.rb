# frozen_string_literal: true

FactoryBot.define do
  factory :user_invite do
    email { Faker::Internet.free_email }

    factory :point_user_invite do
      team { create(:team) }
    end

    factory :pentest_user_invite do
      team { create(:team) }
    end
  end
end
