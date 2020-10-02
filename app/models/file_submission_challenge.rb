# frozen_string_literal: true

class FileSubmissionChallenge < Challenge
  include ShareCalculationModule

  default_scope -> { reorder(:created_at) }

  has_many :file_submissions, inverse_of: :challenge, foreign_key: 'challenge_id', dependent: :destroy,
                              class_name: 'FileSubmission'

  accepts_nested_attributes_for :file_submissions, allow_destroy: true
end
