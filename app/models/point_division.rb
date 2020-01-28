class PointDivision < Division
  belongs_to :game, optional: false, class_name: 'JeopardyGame', inverse_of: :divisions

  has_many :solved_challenges, foreign_key: 'division_id', class_name: 'PointSolvedChallenge', dependent: :destroy
end
