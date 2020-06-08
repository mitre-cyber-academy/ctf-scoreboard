# frozen_string_literal: true

# This is a flag that only belongs to a challenge, not a challenge and a team

class StandardFlag < Flag
  belongs_to :challenge, inverse_of: :flags, class_name: 'StandardChallenge'
  has_many :solved_challenges, inverse_of: :flag, foreign_key: 'flag_id', class_name: 'StandardSolvedChallenge',
                               dependent: :destroy
end
