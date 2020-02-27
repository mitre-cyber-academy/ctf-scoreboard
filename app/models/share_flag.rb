class ShareFlag < Flag
  belongs_to :challenge, inverse_of: :flags, foreign_key: 'challenge_id', class_name: 'ShareChallenge'
  has_many :solved_challenges, inverse_of: :flag, foreign_key: 'flag_id', class_name: 'ShareSolvedChallenge',
                               dependent: :destroy
end
