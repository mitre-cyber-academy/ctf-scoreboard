# frozen_string_literal: true

class PointSolvedChallenge < SolvedChallenge
  after_save :open_next_challenge

  belongs_to :flag, class_name: 'ChallengeFlag', foreign_key: 'flag_id', optional: false, inverse_of: :solved_challenges
  belongs_to :division, class_name: 'PointDivision', inverse_of: :solved_challenges, foreign_key: 'division_id', optional: false
  belongs_to :challenge, class_name: 'PointChallenge', foreign_key: 'challenge_id', optional: false

  def self.solves_by_category_for(team)
    where(team: team).joins(challenge: :category).group('categories.name').count
  end

  def team_can_solve_challenge
    super unless challenge.can_be_solved_by(team)
  end
end
