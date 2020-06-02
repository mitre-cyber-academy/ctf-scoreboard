# frozen_string_literal: true

class StandardSolvedChallenge < SolvedChallenge
  belongs_to :flag, class_name: 'StandardFlag', foreign_key: 'flag_id', optional: false, inverse_of: :solved_challenges

  belongs_to :challenge, class_name: 'StandardChallenge', foreign_key: 'challenge_id', optional: false,
                         inverse_of: :solved_challenges

  def team_can_solve_challenge
    super unless challenge.can_be_solved_by(team)
  end
end
