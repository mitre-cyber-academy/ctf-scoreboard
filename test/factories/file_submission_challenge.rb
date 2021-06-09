FactoryBot.define do
  factory :file_submission_challenge, parent: :challenge, class: 'FileSubmissionChallenge' do
    type { 'FileSubmissionChallenge' }

    factory :closed_file_submission_challenge do
      state { :closed }
    end

    factory :force_closed_file_submission_challenge do
      state { :force_closed }
    end

    factory :file_submission_challenge_with_achievement do
      achievement_name { 'achievement triggered by challenge completion' }
    end
  end
end
