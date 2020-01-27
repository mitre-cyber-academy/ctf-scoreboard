class PointDivision < Division
  has_many :solved_challenges, foreign_key: 'division_id', class_name: 'PointSolvedChallenge', dependent: :destroy
end
