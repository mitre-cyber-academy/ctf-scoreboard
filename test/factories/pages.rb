FactoryBot.define do
  factory :page do
    title { "test custom page" }
    body { "this is the body" }
    path { "page" }

    game
  end
end
