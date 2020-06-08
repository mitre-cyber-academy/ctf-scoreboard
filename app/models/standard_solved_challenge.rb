# frozen_string_literal: true

class StandardSolvedChallenge < SolvedChallenge
  belongs_to :flag, class_name: 'StandardFlag', optional: false, inverse_of: :solved_challenges

  belongs_to :challenge, class_name: 'StandardChallenge', optional: false,
                         inverse_of: :solved_challenges

  def team_can_solve_challenge
    super unless challenge.can_be_solved_by(team)
  end
end
