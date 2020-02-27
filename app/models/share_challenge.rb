# frozen_string_literal: true

class ShareChallenge < BaseShareChallenge
  has_many :solved_challenges, foreign_key: 'challenge_id', inverse_of: :challenge, dependent: :destroy,
                               class_name: 'ShareSolvedChallenge'

  has_many :flags, inverse_of: :challenge, foreign_key: 'challenge_id', class_name: 'PointFlag', dependent: :destroy

  accepts_nested_attributes_for :flags, allow_destroy: true
end
