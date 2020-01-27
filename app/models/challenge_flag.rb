# This is a flag that only belongs to a challenge, not a challenge and a team

class ChallengeFlag < Flag
  belongs_to :challenge, inverse_of: :flags, foreign_key: 'challenge_id', class_name: 'PointChallenge'
  has_many :solved_challenges, inverse_of: :flag, foreign_key: 'flag_id', class_name: 'PointSolvedChallenge', dependent: :destroy
end
