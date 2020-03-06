# frozen_string_literal: true

class StandardChallenge < Challenge
  has_many :flags, inverse_of: :challenge, foreign_key: 'challenge_id', class_name: 'StandardFlag', dependent: :destroy

  has_many :solved_challenges, inverse_of: :challenge, foreign_key: 'challenge_id',
                               class_name: 'StandardSolvedChallenge', dependent: :destroy

  accepts_nested_attributes_for :flags, allow_destroy: true
end
