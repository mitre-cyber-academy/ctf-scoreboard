# frozen_string_literal: true

FactoryBot.define do
  factory :user_request do
    user { create(:user) }

    factory :point_user_request do
      team { create(:team) }
    end

    factory :pentest_user_request do
      team { create(:team) }
    end
  end
end
