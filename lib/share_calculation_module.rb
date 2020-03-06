# frozen_string_literal: true

# This module provides us with the ability to reuse the same share calculation logic
# between ShareChallenges and PentestChallenges, without having to make the two
# dependent on one another. This is important since PentestChallenges are heavily
# calculated within their respective DefenseFlags, however ShareChallenges are mainly
# calculated within the ShareChallenge itself.

# This module assumes your model has the following methods
# initial_shares, current_solve_time, first_solve_time, solved_decrement_period, solved_decrement_shares
# point_value, start_time, unsolved_increment_period, unsolved_increment_points
module ShareCalculationModule
  # Calc shares calculates the share decrease between the first solve time and current time
  def calc_shares(first_solve_time, current_solve_time)
    initial_shares - (((current_solve_time - first_solve_time) / solved_decrement_period.hours) \
      * solved_decrement_shares)
  end

  # Calc point value takes the flag start time and challenge first solve time and calculates
  # the total value of the challenge that will be divided between the solving teams
  def calc_point_value(start_time, first_solve_time)
    point_value + ((first_solve_time - start_time) / unsolved_increment_period.hours) * unsolved_increment_points
  end
end
