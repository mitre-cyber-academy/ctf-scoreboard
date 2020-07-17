FactoryBot.define do
  factory :survey do
    difficulty { 1 }
    realism { 1 }
    interest { 1 }
    comment { "MyText" }
    submitted_flag_id { 1 }
  end
end
