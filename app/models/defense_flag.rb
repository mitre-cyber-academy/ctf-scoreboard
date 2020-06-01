# frozen_string_literal: true

class DefenseFlag < Flag
  # TODO: Validate uniqueness of defense flag per challenge and team

  belongs_to :team, inverse_of: :defense_flags, optional: false
  belongs_to :challenge, inverse_of: :defense_flags, foreign_key: 'challenge_id', class_name: 'PentestChallenge'

  has_many :solved_challenges, -> { ordered }, inverse_of: :flag, foreign_key: 'flag_id',
                                               class_name: 'PentestSolvedChallenge', dependent: :destroy

  has_many :submitted_flags, inverse_of: :flag, foreign_key: 'flag_id', class_name: 'PentestSubmittedFlag',
                             dependent: :destroy

  attr_accessor :submitted_flag

  enum challenge_state: { inherit_parent_state: 0, force_closed: 1 }

  def get_solved_challenge_for(team)
    challenge.get_solved_challenge_for(team, self)
  end

  # Without allow_nil rails_admin cannot load defense_flag new page
  delegate :name, to: :challenge, allow_nil: true
  delegate :description, to: :challenge, allow_nil: true

  def point_value(team)
    if solved_challenges.size.zero? # If nobody has solved
      calc_points_for_first_solve
    elsif solved_by_team?(team) # If current team has solved
      calc_points_for_solved_challenges[team]
    else # If other teams have solved but not the current team
      calc_points_for_solve
    end.round
  end

  def solved?(times = 1)
    solved_challenges.size >= times
  end

  def force_closed?
    super || challenge.force_closed?
  end

  def challenge_open?
    !force_closed? && challenge.challenge_open?
  end

  def open?
    !force_closed? && challenge.open?
  end

  def find_flag(flag_str)
    return self if flag_str == flag
  end

  def start_calculation_at
    super || Game.instance.start
  end

  def can_be_solved_by(team)
    challenge.can_be_solved_by(team, self)
  end

  def first_solve
    # Calling .first queries the database, getting the first index uses the preload
    solved_challenges[0]
  end

  def first_solve_time
    first_solve&.created_at || Game.instance.defense_end
  end

  # Calculates how many points each team should get for solving a specific teams flag
  def calc_points_for_solved_challenges
    team_points = {}
    # Calculate defensive points for teams which still haven't had their challenges solved
    team_points.merge!(team => calc_defensive_points) unless team.nil?
    return team_points if solved_challenges.size.zero?

    # Calculate bonus points that teams receive for solving a challenge. This also calculates defensive points for
    # a team before their challenge was solved.
    team_points.merge_and_sum(calc_first_solve_bonus)
    # Return the bonus points and offensive points hashes merged into 1.
    team_points.merge_and_sum(calc_offensive_points_for_solved_challenges)
  end

  # Bonus points are offensive and defensive points awarded, either for defending for a period of time or
  # successfully being the first to break into a challenge
  def calc_first_solve_bonus
    {
      # Give the team that was first to solve the first capture bonus.
      first_solve.team => challenge.first_capture_point_bonus
    }
  end

  def calc_defensive_points
    challenge.calc_defensive_points(start_calculation_at, first_solve_time)
  end

  def calc_offensive_shares_for_solved_challenges
    solved_challenges.map do |solved_challenge|
      [solved_challenge.team, challenge.calc_shares(first_solve_time, solved_challenge.created_at)]
    end.to_h
  end

  # This takes the challenge first solve time and uses this information to calculate
  # how many points each team actually receives
  def calc_offensive_points_for_solved_challenges
    shares = calc_offensive_shares_for_solved_challenges

    challenge_point_value = challenge.calc_point_value(start_calculation_at, first_solve_time)
    total_shares = shares.values.sum
    shares.map do |team, num_shares|
      [team, convert_shares_to_points_for(num_shares, total_shares, challenge_point_value)]
    end.to_h
  end

  def convert_shares_to_points_for(num_shares, total_shares, challenge_point_value)
    points = (num_shares / total_shares) * challenge_point_value
    points.nan? ? 0 : points
  end

  private

  def calc_points_for_first_solve
    challenge.first_capture_point_bonus + challenge.calc_point_value(start_calculation_at, Time.now.utc)
  end

  def calc_points_for_solve
    potential_shares = challenge.calc_shares(first_solve_time, Time.now.utc)
    convert_shares_to_points_for(
      potential_shares,
      calc_offensive_shares_for_solved_challenges.values.sum + potential_shares,
      challenge.calc_point_value(start_calculation_at, first_solve_time)
    )
  end

  def solved_by_team?(team)
    solved_challenges.find { |sc| sc.team.eql?(team) }
  end
end
