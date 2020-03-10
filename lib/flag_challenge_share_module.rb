# frozen_string_literal: true

# This module allows us to share the logic used to calculate "ShareChallenges" between
# the DefenseFlag class and the ShareChallenge class.

module FlagChallengeShareModule
  def first_solve
    # Calling .first queries the database, getting the first index uses the preload
    solved_challenges[0]
  end

  def display_point_value(team = nil)
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

  def first_solve_time
    first_solve&.created_at || Game.instance.defense_end
  end

  # Calculates how many points each team should get for solving a specific teams flag
  def calc_points_for_solved_challenges
    team_points = {}
    # Calculate defensive points for teams which still haven't had their challenges solved
    # Unless we are instructed to skip defensive calculations
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
      first_solve.team => first_capture_point_bonus
    }
  end

  def calc_defensive_points
    # This is declared on the parent challenge
    calc_defensive_points_helper(start_calculation_at, first_solve_time)
  end

  def calc_offensive_shares_for_solved_challenges
    solved_challenges.map do |solved_challenge|
      [solved_challenge.team, calc_shares(first_solve_time, solved_challenge.created_at)]
    end.to_h
  end

  # This takes the challenge first solve time and uses this information to calculate
  # how many points each team actually receives
  def calc_offensive_points_for_solved_challenges
    shares = calc_offensive_shares_for_solved_challenges

    challenge_point_value = calc_point_value(start_calculation_at, first_solve_time)
    total_shares = shares.values.sum
    shares.transform_values do |num_shares|
      convert_shares_to_points_for(num_shares, total_shares, challenge_point_value)
    end
  end

  def convert_shares_to_points_for(num_shares, total_shares, challenge_point_value)
    points = (num_shares / total_shares) * challenge_point_value
    points.nan? ? 0 : points
  end

  private

  def calc_points_for_first_solve
    first_capture_point_bonus + calc_point_value(start_calculation_at, Time.now.utc)
  end

  def calc_points_for_solve
    potential_shares = calc_shares(first_solve_time, Time.now.utc)
    convert_shares_to_points_for(
      potential_shares,
      calc_offensive_shares_for_solved_challenges.values.sum + potential_shares,
      calc_point_value(start_calculation_at, first_solve_time)
    )
  end

  def solved_by_team?(team)
    solved_challenges.find { |sc| sc.team.eql?(team) }
  end
end
