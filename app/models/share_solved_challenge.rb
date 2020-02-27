# frozen_string_literal: true

class ShareSolvedChallenge < SolvedChallenge
belongs_to :flag, class_name: 'PointFlag', foreign_key: 'flag_id', optional: false

  belongs_to :challenge, class_name: 'ShareChallenge', foreign_key: 'challenge_id', optional: false,
                         inverse_of: :solved_challenges

  def team_can_solve_challenge
    super unless challenge.can_be_solved_by(team)
  end
end
